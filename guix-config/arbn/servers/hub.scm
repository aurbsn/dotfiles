;;; hub.scm: Hetzner VPS for use as WireGuard hub and static site host.
;;; - Never change `host-name': `guix deploy' finds the server on Hetzner by
;;;   that name, so renaming it provisions a second server.

(use-modules (gnu)
             (gnu machine)
             (gnu machine hetzner)
             (guix utils)
             (arbn modules wireguard))
(use-service-modules mcron networking ssh sysctl)

(define %server-type "cpx21")
(define %location "ash")

(define %ssh-keys
  (list (local-file "../../ssh-keys/arbn-desktop.pub")
        (local-file "../../ssh-keys/arbn-dev.pub")))

(define %gc-job
  #~(job "17 4 * * *" "guix gc -F 10G"))

;; Drop everything inbound except SSH, WireGuard and anything arriving
;; through the tunnel.  Forward only between tunnel peers
(define %ruleset
  (plain-file "hub.nft" "\
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    ct state invalid drop
    ct state { established, related } accept
    iifname \"lo\" accept
    meta l4proto { icmp, ipv6-icmp } accept
    tcp dport 22 accept
    udp dport 51820 accept
    iifname \"wg0\" accept
  }
  chain forward {
    type filter hook forward priority 0; policy drop;
    iifname \"wg0\" oifname \"wg0\" accept
  }
  chain output {
    type filter hook output priority 0; policy accept;
  }
}"))

(define %base
  (make-hetzner-os %server-type))

(define %hub
  (operating-system
    (inherit %base)
    (host-name "arbn-hub")
    (timezone "Etc/UTC")
    (services
     (cons*
      (wireguard-hub-service)
      (service nftables-service-type
               (nftables-configuration (ruleset %ruleset)))
      (simple-service 'gc-job mcron-service-type (list %gc-job))
      (simple-service 'ip-forward sysctl-service-type
                      '(("net.ipv4.ip_forward" . "1")))
      (modify-services (operating-system-user-services %base)
        (openssh-service-type
         config => (openssh-configuration
                    (inherit config)
                    (password-authentication? #f)
                    (authorized-keys
                     `(("root" ,@%ssh-keys))))))))))

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
