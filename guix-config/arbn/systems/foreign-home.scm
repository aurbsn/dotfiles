(define-module (arbn systems foreign-home))
(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu packages)
             (arbn modules package-lists)
             (arbn modules service-lists))
(use-package-modules node)

(home-environment (services
                   (create-home-services
                    (list (simple-service 'npm-prefix
                                          home-environment-variables-service-type
                                          '(("NPM_CONFIG_PREFIX" . "$HOME/.local"))))
                    '()
                    #:fhs-box? #f))
                  (packages
                   (cons node %desktop-home-packages)))
