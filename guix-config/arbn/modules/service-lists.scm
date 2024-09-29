(define-module (arbn modules service-lists)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells))
(use-service-modules guix cups desktop networking ssh xorg avahi dbus sound pm)

(define-public (create-home-services my-services my-files)
  (list
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
                            (channel
                             (name 'guix-hpc-non-free)
                             (url "https://gitlab.inria.fr/guix-hpc/guix-hpc-non-free.git"))
                            (channel
                             (name 'guix-science-nonfree)
                             (url "https://github.com/guix-science/guix-science-nonfree.git")
                             (introduction
                              (make-channel-introduction
                               "58661b110325fd5d9b40e6f0177cc486a615817e"
                               (openpgp-fingerprint
                                "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
                            %default-channels)))
           `(".emacs.d/init.el"
             ,(local-file "../../config-files/emacs.d/init.el" #:recursive? #t))
           `(".emacs.d/customizations"
             ,(local-file "../../config-files/emacs.d/customizations" #:recursive? #t))
           `(".emacs.d/env"
	     ,(local-file "../../config-files/emacs.d/env" #:recursive? #t))
           `(".sbclrc"
             ,(local-file "../../config-files/sbclrc"))
           `(".gitconfig"
             ,(local-file "../../config-files/gitconfig")))))))

(define-public (create-system-services my-services)
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
                                   %default-authorized-guix-keys))))))
