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
            `(".emacs.d/init.el"
             ,(local-file "config-files/emacs.d/init.el" #:recursive? #t))
            `(".emacs.d/customizations"
              ,(local-file "config-files/emacs.d/customizations" #:recursive? #t))
	    `(".emacs.d/env"
	      ,(local-file "config-files/emacs.d/env" #:recursive? #t))
            `(".sbclrc"
              ,(local-file "config-files/sbclrc"))))))
  (packages
    (map (compose list specification->package+output)
         (list "guile"
               "xclip"
               "sbcl"
               "font-adobe-source-code-pro"
               "emacs"
               "emacs-vterm"
               "nyxt"
               "unzip"
               "libgnome-keyring"
               "glibc-locales"
               "nss-certs"
               "font-wqy-zenhei"
               "font-wqy-microhei"
               "font-adobe-source-han-sans:cn" 
               "xlsfonts"
               "syncthing"
               "cmake"
               "cl-slime-swank"
               "cl-drakma"
               "cl-fiveam"
               "cl-json"
               "xlsx2csv"
               "git"
               "exercism"
               "libreoffice"
               "borg"
               "borgmatic"
               "oath-toolkit"
               "make"

               ;; gstreamer plugins
               "gstreamer"
               "gst-plugins-base"
               "gst-plugins-good"
               "gst-plugins-bad"
               "gst-plugins-ugly"
               "gst-libav"))))
