;;; hub.scm: Hetzner VPS for use as WireGuard hub and static site host.
;;; - Never change `host-name': `guix deploy' finds the server on Hetzner by
;;;   that name, so renaming it provisions a second server.

(use-modules (gnu)
             (gnu machine)
             (gnu machine hetzner)
             (guix utils)
             (arbn modules wireguard)
             (ice-9 match))
(use-package-modules rsync)
(use-service-modules certbot mcron networking ssh sysctl web)

(define %server-type "cpx21")
(define %location "ash")

(define %desktop-key (local-file "../../ssh-keys/arbn-desktop.pub"))

(define %ssh-keys
  (list %desktop-key
        (local-file "../../ssh-keys/arbn-dev.pub")))

(define %canonical-domain "arbn.nyc")
(define %domains '("arbn.nyc" "arbn.dev" "arbn.codes"))
(define %site-root "/srv/www")
(define %https-listen '("443 ssl" "[::]:443 ssl"))

(define (www domain)
  (string-append "www." domain))

(define (certificate-file domain file)
  (string-append "/etc/certs/" domain "/" file))

(define (domain-certificate domain)
  (certificate-configuration
   (domains (list domain (www domain)))))

(define %site-server
  (nginx-server-configuration
   (listen %https-listen)
   (server-name (list %canonical-domain))
   (root %site-root)
   (ssl-certificate (certificate-file %canonical-domain "fullchain.pem"))
   (ssl-certificate-key (certificate-file %canonical-domain "privkey.pem"))))

(define (redirect-server domain)
  (nginx-server-configuration
   (listen %https-listen)
   (server-name (if (string=? domain %canonical-domain)
                    (list (www domain))
                    (list domain (www domain))))
   (ssl-certificate (certificate-file domain "fullchain.pem"))
   (ssl-certificate-key (certificate-file domain "privkey.pem"))
   (locations
    (list (nginx-location-configuration
           (uri "/")
           (body (list (string-append "return 301 https://"
                                      %canonical-domain
                                      "$request_uri;"))))))))

(define %www-user
  (user-account
   (name "www")
   (group "www")
   (comment "Static site publisher")
   (home-directory "/home/www")))

;; The home directory is created 0700, which nginx can't read, so the site
;; root is a separate directory.
(define %site-root-activation
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils))
        (let ((user (getpwnam "www")))
          (mkdir-p #$%site-root)
          (chown #$%site-root (passwd:uid user) (passwd:gid user))
          (chmod #$%site-root #o755)))))

(define %gc-job
  #~(job "17 4 * * *" "guix gc -F 10G"))

;; Drop everything inbound except SSH, HTTP(S), WireGuard and anything arriving
;; through the tunnel.  Forward between tunnel peers, and from exit nodes out
;; to the internet.
(define %ruleset
  (plain-file
   "hub.nft"
   (string-append
    "\
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    ct state { established, related } accept
    ct state invalid drop
    iifname \"lo\" accept
    meta l4proto { icmp, ipv6-icmp } accept
    tcp dport { 22, 80, 443 } accept
    udp dport 51820 accept
    iifname \"wg0\" accept
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
    ct state { established, related } accept
    iifname \"wg0\" oifname \"wg0\" accept
"
    (match (wireguard-exit-addresses)
      (() "")
      (addresses
       (string-append "    iifname \"wg0\" ip saddr { "
                      (string-join addresses ", ")
                      " } accept\n")))
    "  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}
table ip nat {
  chain postrouting {
    type nat hook postrouting priority 100; policy accept;
    ip saddr " %subnet " oifname != \"wg0\" masquerade
  }
}")))

(define %base
  (make-hetzner-os %server-type))

(define %hub
  (operating-system
    (inherit %base)
    (host-name "arbn-hub")
    (timezone "Etc/UTC")
    (packages (cons rsync (operating-system-packages %base)))
    (users (cons %www-user (operating-system-users %base)))
    (groups (cons (user-group (name "www"))
                  (operating-system-groups %base)))
    (services
     (cons*
      (wireguard-hub-service)
      (service nftables-service-type
               (nftables-configuration (ruleset %ruleset)))
      (service certbot-service-type
               (certbot-configuration
                (email "arbn@arbn.nyc")
                (certificates (map domain-certificate %domains))))
      (service nginx-service-type
               (nginx-configuration
                (server-blocks
                 (cons %site-server (map redirect-server %domains)))))
      (simple-service 'site-root activation-service-type
                      %site-root-activation)
      (simple-service 'gc-job mcron-service-type (list %gc-job))
      (simple-service 'ip-forward sysctl-service-type
                      '(("net.ipv4.ip_forward" . "1")))
      (modify-services (operating-system-user-services %base)
        (openssh-service-type
         config => (openssh-configuration
                    (inherit config)
                    (password-authentication? #f)
                    (authorized-keys
                     `(("root" ,@%ssh-keys)
                       ("www" ,%desktop-key))))))))))

(list (machine
       (operating-system %hub)
       (environment hetzner-environment-type)
       (configuration
        (hetzner-configuration
         (server-type %server-type)
         (location %location)
         (ssh-public-key
          (string-append (current-source-directory)
                         "/../../ssh-keys/arbn-desktop.pub"))
         (delete? #f)))))
