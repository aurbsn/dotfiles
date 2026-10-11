(define-module (arbn modules wireguard)
  #:use-module (gnu services)
  #:use-module (gnu services vpn)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (wireguard-hub-service
            wireguard-client-service))

(define %subnet "10.47.0.0/24")
(define %prefix-length "/24")

(define %hub "arbn-hub")
(define %hub-endpoint "5.161.160.215:51820")

;; (NAME TUNNEL-ADDRESS PUBLIC-KEY)
(define %nodes
  '(("arbn-hub"     "10.47.0.1" "25HscAUa/YiQbkuyiddBcIL25QYu5EdX0J6fBQZM1yw=")
    ("arbn-desktop" "10.47.0.2" "hCJSPe1z2b8PCF/LSc00wsfokCbA+FGD+5DE4I1M9BI=")
    ("arbn-dev"  "10.47.0.3" "zZVKg0AQJyDZjAKABQLoCVpfRSoJszS1GHACXIGE1S0=")))

(define (node name)
  (or (assoc name %nodes)
      (error "unknown WireGuard node" name)))

(define (node-address name)
  (match (node name) ((_ address _) address)))

(define (node-public-key name)
  (match (node name) ((_ _ key) key)))

(define (wireguard-hub-service)
  "Return the WireGuard service for the hub: one peer per client"
  (service wireguard-service-type
           (wireguard-configuration
            (addresses (list (string-append (node-address %hub)
                                            %prefix-length)))
            (peers
             (filter-map
              (match-lambda
                ((name address key)
                 (and key
                      (not (string=? name %hub))
                      (wireguard-peer
                       (name name)
                       (public-key key)
                       (allowed-ips (list (string-append address "/32")))))))
              %nodes)))))

(define (wireguard-client-service name)
  "Return the WireGuard service for client NAME: the hub is its only peer,
and the whole tunnel subnet is routed through it"
  (service wireguard-service-type
           (wireguard-configuration
            (addresses (list (string-append (node-address name)
                                            %prefix-length)))
            (peers
             (match (node-public-key %hub)
               (#f '())
               (key
                (list (wireguard-peer
                       (name %hub)
                       (endpoint %hub-endpoint)
                       (public-key key)
                       (allowed-ips (list %subnet))
                       ;; Keeps the NAT mapping open so the hub can always
                       ;; reach this machine.
                       (keep-alive 25)))))))))
