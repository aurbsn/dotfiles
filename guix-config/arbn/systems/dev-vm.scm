(use-modules (gnu)
             (gnu home)
             (gnu packages)
             (arbn modules package-lists)
             (arbn modules service-lists))
(use-package-modules node)

(home-environment (services
                   (create-home-services '() '()))
                  (packages
                   (append (list node-lts) %base-home-packages)))
