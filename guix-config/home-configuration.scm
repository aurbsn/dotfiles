;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu packages wm)
  (gnu services)
  (guix gexp)
  (gnu home services)
  (gnu home services syncthing)
  (gnu home services sound)
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

     (service home-syncthing-service-type)
     (service home-pipewire-service-type)
     (service home-dbus-service-type)
     (service home-xmodmap-service-type
         (home-xmodmap-configuration
          (key-map '(("remove Lock" . "Caps_Lock")
                     ("keysym Control_L" . "Control_L")
                     ("add Lock" . "Caps_Lock")))))

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
             ,(local-file "config-files/emacs.d/init.el" #:recursive? #t))
            `(".emacs.d/customizations"
              ,(local-file "config-files/emacs.d/customizations" #:recursive? #t))
	    `(".emacs.d/env"
	      ,(local-file "config-files/emacs.d/env" #:recursive? #t))
            `(".stumpwmd/init.lisp"
              ,(local-file "config-files/stumpwm.d/init.lisp"))
            `(".sbclrc"
              ,(local-file "config-files/sbclrc"))
            `("bin/wrappedhl.sh"
              ,(local-file "config-files/wrappedhl.sh"))
            `(".config/waybar/config"
              ,(local-file "config-files/waybar/conf"))
            `(".config/hypr/hyprland.conf"
              ,(local-file "config-files/hyprland.conf"))))))
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
         "font-adobe-source-code-pro"
         "emacs"
         "emacs-vterm"
         "nyxt"
         "exercism"
         "rust"
         "rust-cargo"
         "exercism"

         "steam-nvidia"
         "flatpak"
         "gnome-themes-extra"
         "nordic-theme"
         "lxappearance"
         "font-google-noto"
         "unzip"
         "hyprcursor"
         "vlc"
         "waybar"
         "mako"
         "firefox"
         "syncthing"
         "keepassxc"))))
