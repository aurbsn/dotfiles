(define-module (arbn systems arbn-dev))
(use-modules (gnu)
             (gnu home)
             (gnu packages)
             (arbn modules package-lists)
             (arbn modules service-lists))

(home-environment (services
                   (create-home-services '() '()))
                  (packages
                   %desktop-home-packages))
