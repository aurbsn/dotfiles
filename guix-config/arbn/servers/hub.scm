;;; hub.scm: Hetzner VPS for use as WireGuard hub and static site host.
;;; - Never change `host-name': `guix deploy' finds the server on Hetzner by
;;;   that name, so renaming it provisions a second server.

(use-modules (gnu)
             (gnu machine)
             (gnu machine hetzner)
             (guix utils))
(use-service-modules mcron ssh)

(define %server-type "cpx21")
(define %location "ash")

(define %ssh-keys
  (list (local-file "../../ssh-keys/arbn-desktop.pub")
        ;;(local-file "../../ssh-keys/arbn-dev.pub")
        ))

(define %gc-job
  #~(job "17 4 * * *" "guix gc -F 10G"))

(define %base
  (make-hetzner-os %server-type))

(define %hub
  (operating-system
   (inherit %base)
   (host-name "arbn-hub")
   (timezone "Etc/UTC")
   (services
    (cons (simple-service 'gc-job mcron-service-type (list %gc-job))
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
         (ssh-public-key (string-append (current-source-directory) "/../../ssh-keys/arbn-desktop.pub"))
         (delete? #f)))))
