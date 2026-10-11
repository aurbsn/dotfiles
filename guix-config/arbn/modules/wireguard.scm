(define-module (arbn modules wireguard)
  #:use-module (gnu services)
  #:use-module (gnu services vpn)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (%subnet
            wireguard-hub-service
            wireguard-client-service
            wireguard-exit-service
            wireguard-exit-addresses))

(define %subnet "10.47.0.0/24")
(define %prefix-length "/24")

(define %hub "arbn-hub")
(define %hub-endpoint "5.161.160.215:51820")

;; Quad9 DNS
(define %exit-dns '("9.9.9.9" "149.112.112.112"))

;; (NAME TUNNEL-ADDRESS PUBLIC-KEY EXIT?)
(define %nodes
  '(("arbn-hub"
     "10.47.0.1"
     "25HscAUa/YiQbkuyiddBcIL25QYu5EdX0J6fBQZM1yw="
     #f)
    ("arbn-desktop"
     "10.47.0.2"
     "hCJSPe1z2b8PCF/LSc00wsfokCbA+FGD+5DE4I1M9BI="
     #f)
    ("arbn-dev"
     "10.47.0.3"
     "zZVKg0AQJyDZjAKABQLoCVpfRSoJszS1GHACXIGE1S0="
     #f)
    ("arbn-dev-exit"
     "10.47.0.4"
     "D33lJ5q84ZDgXtTkzpiEfCYbX2jwqhzSBJTUTM9YEBw="
     #t)))

(define (node name)
  (or (assoc name %nodes)
      (error "unknown WireGuard node" name)))

(define (node-address name)
  (match (node name) ((_ address _ _) address)))

(define (node-public-key name)
  (match (node name) ((_ _ key _) key)))

(define (wireguard-exit-addresses)
  "Return the tunnel addresses allowed to reach the internet via the hub"
  (filter-map (match-lambda
                ((_ address _ exit?) (and exit? address)))
              %nodes))

(define (wireguard-hub-service)
  "Return the WireGuard service for the hub: one peer per client"
  (service wireguard-service-type
           (wireguard-configuration
            (addresses (list (string-append (node-address %hub)
                                            %prefix-length)))
            (peers
             (filter-map
              (match-lambda
                ((name address key _)
                 (and key
                      (not (string=? name %hub))
                      (wireguard-peer
                       (name name)
                       (public-key key)
                       (allowed-ips (list (string-append address "/32")))))))
              %nodes)))))

(define (hub-peers allowed-ips)
  "Return the hub as the only peer, routing ALLOWED-IPS through it, or no
peers while the hub's key is unknown"
  (match (node-public-key %hub)
    (#f '())
    (key
     (list (wireguard-peer
            (name %hub)
            (endpoint %hub-endpoint)
            (public-key key)
            (allowed-ips allowed-ips)
            ;; Keeps the NAT mapping open so the hub can always reach this
            ;; machine.
            (keep-alive 25))))))

(define (wireguard-client-service name)
  "Return the WireGuard service for client NAME: the hub is its only peer,
and the whole tunnel subnet is routed through it"
  (service wireguard-service-type
           (wireguard-configuration
            (addresses (list (string-append (node-address name)
                                            %prefix-length)))
            (peers (hub-peers (list %subnet))))))

(define (wireguard-exit-service name)
  "Return an on-demand WireGuard interface, wg1, for exit node NAME: while it is
up, all traffic goes out through the hub."
  (service wireguard-service-type
           (wireguard-configuration
            (interface "wg1")
            (port 51821)                ;wg0 already listens on 51820
            (private-key "/etc/wireguard/wg1.key")
            ;; /32, so it doesn't compete with wg0's route to the subnet;
            ;; traffic for other tunnel peers keeps using wg0.
            (addresses (list (string-append (node-address name) "/32")))
            (dns %exit-dns)
            (auto-start? #f)
            ;; IPv6 too, so it can't leak around the tunnel.  The tunnel is
            ;; IPv4-only, so there is no IPv6 while it's up.
            (peers (hub-peers '("0.0.0.0/0" "::/0"))))))
