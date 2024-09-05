(use-modules (gnu)
             (gnu home)
             (gnu packages)
             (gnu services)
             (gnu home services)
             (gnu home services shells))

(home-environment (services
                   (list 
                    (service
                     home-bash-service-type
                     (home-bash-configuration
                      (bash-profile 
                       (list (local-file
                              "../config-files/bash_profile"
                              "bash_profile")))
                      (bashrc
                       (list (local-file
                              "../config-files/bashrc"
                              "bashrc")))
                      (bash-logout
                       (list (local-file
                              "../config-files/bash_logout"
                              "bash_logout")))))

                                        ; Configuration files
                    (simple-service 
                     'home-config
                     home-files-service-type
                     (list `(".config/guix/channels.scm"
                             ,(scheme-file "channels.scm" '
                                           (cons* 
                                            (channel
                                             (name 'nonguix)
                                             (url "https://gitlab.com/nonguix/nonguix")
                                             ;; Enable signature verification:
                                             (introduction
                                              (make-channel-introduction
                                               "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                               (openpgp-fingerprint
                                                "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
                                            
                                            (channel
                                             (name 'rosenthal)
                                             (url "https://codeberg.org/hako/rosenthal.git")
                                             (branch "trunk")
                                             (introduction
                                              (make-channel-introduction
                                               "7677db76330121a901604dfbad19077893865f35"
                                               (openpgp-fingerprint 
                                                "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
                                            %default-channels)))
                           `(".emacs.d/init.el"
                             ,(local-file "../config-files/emacs.d/init.el" #:recursive? #t))
                           `(".emacs.d/customizations"
                             ,(local-file "../config-files/emacs.d/customizations" #:recursive? #t))
	                   `(".emacs.d/env"
	                     ,(local-file "../config-files/emacs.d/env" #:recursive? #t))
                           `(".sbclrc"
                             ,(local-file "../config-files/sbclrc"))))))
                  (packages
                   (map (compose list specification->package+output)
                        (list 
                         "git"
                         "nss-certs"
                         "glibc"
                         "glibc:static"
                         "glibc-locales"
                         "guile"
                         "xclip"
                         "sbcl"
                         "emacs"
                         "emacs-vterm"
                         "exercism"
                         "rust"
                         "rust-cargo"
                         "font-adobe-source-code-pro"))))
