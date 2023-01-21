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
              ,(scheme-file "channels.scm" '(cons* 
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
            `(".config/common-lisp/source-registry.conf.d/arbn-lisp.conf"
              ,(local-file "config-files/arbn-lisp.conf"))
            `(".xsession"
              ,(local-file "config-files/xinitrc" #:recursive? #t))
            `(".xinitrc"
              ,(local-file "config-files/xinitrc" #:recursive? #t))
            `(".emacs.d/init.el"
             ,(local-file "config-files/emacs.d/init.el" #:recursive? #t))
            `(".emacs.d/customizations"
              ,(local-file "config-files/emacs.d/customizations" #:recursive? #t))
	    `(".emacs.d/env"
	      ,(local-file "config-files/emacs.d/env" #:recursive? #t))
            `(".stumpwm.d/init.lisp"
             ,(local-file "config-files/stumpwm.d/init.lisp" #:recursive? #t))
            `(".stumpwm.d/modules"
             ,(local-file "config-files/stumpwm.d/modules" #:recursive? #t))
            `("dev/start-stump.lisp"
              ,(local-file "config-files/start-stump.lisp"))
            `(".sbclrc"
              ,(local-file "config-files/sbclrc"))
            `(".mbsyncrc"
              ,(local-file "config-files/mbsyncrc"))
            `(".screenlayout/docked.sh"
              ,(local-file "config-files/docked.sh" #:recursive? #t))
            `(".config/nyxt/init.lisp" 
              ,(local-file "config-files/nyxt/init.lisp"))))))
  (packages
    (map (compose list specification->package+output)
         (list "mu"
               "isync"
               "guile"
               "xclip"
               "sbcl"
               "acpi"
               "font-adobe-source-code-pro"
               "emacs"
               "emacs-vterm"
               "nyxt"
               "unzip"
               "libgnome-keyring"
               "glibc-locales"
               "nss-certs"
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
               "cl-drakma"
               "cl-fiveam"
               "cl-json"
               "qt5ct"
               "hledger"
               "emacs-hledger-mode"
               "xlsx2csv"
               "git"
               "exercism"
               "libreoffice"
               "autorandr"
               "borg"
               "borgmatic"
               "oath-toolkit"
               "password-store"

               ;; gstreamer plugins
                "gstreamer"
                "gst-plugins-base"
                "gst-plugins-good"
                "gst-plugins-bad"
                "gst-plugins-ugly"
                "gst-libav"))))
