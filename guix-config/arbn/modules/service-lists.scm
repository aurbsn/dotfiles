(define-module (arbn modules service-lists)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services gnupg)
  #:use-module (ice-9 curried-definitions))
(use-package-modules security-token gnupg fcitx5)
(use-service-modules guix cups desktop networking ssh xorg avahi dbus sound pm
                     security-token)

(define-public %nonguix-channel
  '(channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")
    (introduction
     (make-channel-introduction
      "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
      (openpgp-fingerprint
       "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define-public %arbn-channel
  '(channel
    (name 'arbn)
    (url "https://github.com/aurbsn/arbn-guix-channel.git")
    (branch "main")
    (introduction
     (make-channel-introduction
      "3cc6977711fa11f94760bfd97be6723e56a51222"
      (openpgp-fingerprint
       "FD2F 077F 9BD6 CBB3 471A  D63A 3029 8DA2 EEB5 DE28")))))

(define %fido2-rule
  (udev-rule
   "90-fido2.rules"
   (string-append "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idProduct}==\"0407\", GROUP=\"plugdev\", ATTRS{idVendor}==\"1050\" TAG+=\"uaccess\"" "\n")))

(define-public %yubikey-services
  (list (service pcscd-service-type)
        (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))
        (udev-rules-service 'u2f %fido2-rule #:groups '("plugdev"))))

(define*-public (create-home-services my-services my-files #:key (free #f))
  (append (list
	   (service home-shepherd-service-type)
           (simple-service 'home-env-vars
                           home-environment-variables-service-type
                           `(("EDITOR" . "emacsclient")
                             ("LANG" . "en_US.UTF-8")
                             ("GUILE_LOAD_PATH" . "$HOME/dev/dotfiles/guix-config:$GUILE_LOAD_PATH")
                             ("NODE_OPTIONS" . "--max-old-space-size=8192")
                             ("GDK_SCALE" . "2")
                             ("XDG_DATA_DIRS" . "/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS")
                             ("GTK_IM_MODULE" . "fcitx")
                             ("QT_IM_MODULE" . "fcitx")
                             ("XMODIFIERS" . "@im=fcitx")
                             ("SDL_IM_MODULE" . "fcitx")
                             ("PATH" . "$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/bin:$PATH")))
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
           (service home-gpg-agent-service-type
                    (home-gpg-agent-configuration 
                     (pinentry-program (file-append pinentry "/bin/pinentry"))))
           (simple-service 'flatpak-visible-fonts
                           home-activation-service-type
                           #~(begin
                               (use-modules (guix build utils))
                               (let ((dest (string-append (getenv "HOME")
                                                          "/.local/share/fonts/guix")))
                                 (mkdir-p dest)
                                 (system* "chmod" "-R" "u+w" dest)
                                 (system* "cp" "-rfL" "--no-preserve=mode"
                                          (string-append (getenv "HOME")
                                                         "/.guix-home/profile/share/fonts/.")
                                          dest))))
           (simple-service 'fcitx5-daemon
                    home-shepherd-service-type
                    (list (shepherd-service
                           (provision '(fcitx5))
                           (documentation "Fcitx5 input method daemon.")
                           (start #~(make-forkexec-constructor
                                     (list #$(file-append fcitx5 "/bin/fcitx5"))))
                           (stop #~(make-kill-destructor)))))
           
           ; Configuration files
           (simple-service 
            'home-config
            home-files-service-type
            (append
             my-files
             (list `(".config/guix/channels.scm"
                     ,(scheme-file "channels.scm"
                                   `(cons* ,@(if free '() (list %nonguix-channel))
                                           ,%arbn-channel
                                           %default-channels)))
	           `(".emacs.d/early-init.el"
                     ,(local-file "../../config-files/emacs.d/early-init.el" #:recursive? #t))
                   `(".emacs.d/init.el"
                     ,(local-file "../../config-files/emacs.d/init.el" #:recursive? #t))
                   `(".emacs.d/customizations"
                     ,(local-file "../../config-files/emacs.d/customizations" #:recursive? #t))
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
