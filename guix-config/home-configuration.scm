;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services)
  (gnu home services shells)
  (gnu home services desktop))

(home-environment
 (services
  (list 
   ; Bash
   (service
      home-bash-service-type
      (home-bash-configuration
       (bash-profile 
        (list (local-file
               "config-files/bash_profile"
               "bash_profile")))
       (bashrc
        (list (local-file
               "config-files/bashrc"
               "bashrc")))
       (bash-logout
        (list (local-file
               "config-files/bash_logout"
               "bash_logout")))))

     ; Configuration files
     (simple-service 'home-config
      home-files-service-type
      (list `(".config/guix/channels.scm"
              ,(scheme-file "channels.scm" '(cons* (channel
                                                    (name 'flat)
                                                    (url "https://github.com/flatwhatson/guix-channel.git")
                                                    (introduction
                                                     (make-channel-introduction
                                                      "33f86a4b48205c0dc19d7c036c85393f0766f806"
                                                      (openpgp-fingerprint
                                                       "736A C00E 1254 378B A982  7AF6 9DBE 8265 81B6 4490"))))
                                                   (channel
                                                    (name 'nonguix)
                                                    (url "https://gitlab.com/nonguix/nonguix")
                                                    ;; Enable signature verification:
                                                    (introduction
                                                     (make-channel-introduction
                                                      "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
                                                      (openpgp-fingerprint
                                                       "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
                                                   %default-channels)))
            ;; `(".xsession"
            ;;   ,(local-file "config-files/xsession"))
            ;`(".emacs.d"
            ;  ,(local-file "config-files/emacs.d" #:recursive? #t))
            ;`(".stumpwm.d"
            ;  ,(local-file "config-files/stumpwm.d" #:recursive? #t))
            `("dev/start-stump.lisp"
              ,(local-file "config-files/start-stump.lisp"))
            `(".sbclrc"
              ,(local-file "config-files/sbclrc"))
            `(".mbsyncrc"
              ,(local-file "config-files/mbsyncrc"))
            `(".screenlayout/docked.sh"
              ,(local-file "config-files/docked.sh"))
            `(".Xresources"
              ,(local-file "config-files/Xresources"))))))
  (packages
    (map (compose list specification->package+output)
         (list "mu"
               "isync"
               "guile"
               "xclip"
               "sbcl"
               "keepassxc"
               "acpi"
               "font-adobe-source-code-pro"
               "emacs-native-comp"
               "emacs-vterm"
               "nyxt"
               "unzip"
               "libgnome-keyring"
               "fcitx5"
               "fcitx5-configtool"
               "fcitx5-chinese-addons"
               "fcitx5-gtk"
               "fcitx5-qt"
               "font-wqy-zenhei"
               "font-wqy-microhei"
               "font-adobe-source-han-sans:cn" 
               "xlsfonts"
               "syncthing"
               "cmake"
               "cl-stumpwm"
               "cl-slime-swank"
               "cl-clx-truetype"
               "sbcl-stumpwm-ttf-fonts"
               "cl-fiveam"
               "qt5ct"
               "ledger"
               "emacs-ledger-mode"
               "xlsx2csv"
               "git"
               "exercism"
               "libreoffice"))))
