(define-module (arbn modules service-lists)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (ice-9 curried-definitions))
(use-package-modules security-token)
(use-service-modules guix cups desktop networking ssh xorg avahi dbus sound pm)

(define*-public (create-home-services my-services my-files #:key (free #f))
  (append (list
	   (service home-shepherd-service-type)
           (service
            home-bash-service-type
            (home-bash-configuration
             (guix-defaults? #f)
             (bash-profile 
              (list (local-file
                     "../../config-files/bash_profile"
                     "bash_profile")))
             (bashrc
              (list (local-file
                     "../../config-files/bashrc"
                     "bashrc")))
             (bash-logout
              (list (local-file
                     "../../config-files/bash_logout"
                     "bash_logout")))))

           ; Configuration files
           (simple-service 
            'home-config
            home-files-service-type
            (append
             my-files
             (list `(".config/guix/channels.scm"
                     ,(scheme-file "channels.scm"
                                   `(cons* 
                                     ,(if (not free)
                                         '(channel
                                          (name 'nonguix)
                                          (url "https://gitlab.com/nonguix/nonguix")
                                          ;; Enable signature verification:
                                          (introduction
                                           (make-channel-introduction
                                            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                            (openpgp-fingerprint
                                             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
                                     (channel
                                      (name 'arbn)
                                      (url "https://git.disroot.org/arbn/arbn-guix-channel")
                                      (branch "main")
                                      (introduction
                                       (make-channel-introduction
                                        "3cc6977711fa11f94760bfd97be6723e56a51222"
                                        (openpgp-fingerprint
                                         "FD2F 077F 9BD6 CBB3 471A  D63A 3029 8DA2 EEB5 DE28"))))
                                     %default-channels)))
	           `(".emacs.d/early-init.el"
                     ,(local-file "../../config-files/emacs.d/early-init.el" #:recursive? #t))
                   `(".emacs.d/init.el"
                     ,(local-file "../../config-files/emacs.d/init.el" #:recursive? #t))
                   `(".emacs.d/customizations"
                     ,(local-file "../../config-files/emacs.d/customizations" #:recursive? #t))
                   `(".emacs.d/env"
	             ,(local-file "../../config-files/emacs.d/env" #:recursive? #t))
                   `(".sbclrc"
                     ,(local-file "../../config-files/sbclrc"))
                   `(".gitconfig"
                     ,(local-file "../../config-files/gitconfig"))))))
          my-services))

(define*-public (create-system-services my-services #:key (free #f))
  (if (not free)
      (modify-services 
       my-services
       (guix-service-type config => 
                          (guix-configuration
                           (inherit config)
                           (substitute-urls
                            (append (list "https://substitutes.nonguix.org")
                                    %default-substitute-urls))
                           (authorized-keys
                            (append (list (local-file "../../signing-key.pub"))
                                    %default-authorized-guix-keys)))))
      my-services))
