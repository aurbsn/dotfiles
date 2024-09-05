(define-module (arbn system arbn-desktop)
  #:use-module (gnu)
  #:use-module (base-system)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages networking)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu packages wm)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop)
  #:use-module (rosenthal packages wm))
(use-service-modules cups desktop networking ssh xorg dbus nix)

(system-config
 #:system
 (
  (kernel-arguments '("modprobe.blacklist=nouveau"
                      ;; Set this if the card is not used for displaying or
                      ;; you're using Wayland:
                      "nvidia_drm.modeset=1"))

  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (keyboard-layout (keyboard-layout "us"))
  (host-name "arbn-desktop")

  (mapped-devices (list (mapped-device
                         (source (uuid
                                  "c300b946-fd97-4dc1-b4ab-b2fd7cdb2891"))
                         (target "cryptroot")
                         (type luks-device-mapping))))

  (file-systems (cons* (file-system
                        (mount-point "/boot/efi")
                        (device (uuid "F1DB-22A3"
                                      'fat32))
                        (type "vfat"))
                       (file-system
                        (mount-point "/")
                        (device "/dev/mapper/cryptroot")
                        (type "ext4")
                        (dependencies mapped-devices)) %base-file-systems))
  (services (append (list
                     (service nix-service-type)
                     (service nvidia-service-type)
                     (service cups-service-type)
                     (service bluetooth-service-type
                              (bluetooth-configuration
                               (auto-enable? #t)))
                     (set-xorg-configuration
                      (xorg-configuration
                       (modules (cons nvda %default-xorg-modules))
                       (drivers '("nvidia"))
                       (keyboard-layout keyboard-layout))))
                    (modify-services %desktop-services
                                     (dbus-root-service-type config => 
                                                             (dbus-configuration (inherit config)
                                                                                 (services (list blueman))))
                                     (delete gdm-service-type))))
  (packages
    (append (list (replace-mesa hyprland)
                  xdg-desktop-portal-hyprland
                  xdg-desktop-portal
                  xdg-desktop-portal-gtk
                  kitty
                  wofi
                  (replace-mesa flatpak))
            (map specification->package 
                 (list 
                  "glibc-locales"
		  
                  "mg"
                  "git"
                  
                  "blueman"
                  "bluez"
                  "bluez-alsa"
                  "pulseaudio"

                  ;; other
                  "curl"
                  "setxkbmap"
                  "openssh"
                  )))))
 #:home
 (home-environment (services
                    (list
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
                          "emacs"
                          "emacs-vterm"
                          "exercism"
                          "rust"
                          "rust-cargo"
                          "exercism"

                          "steam-devices-udev-rules"
                          "steam-nvidia"

                          "font-adobe-source-code-pro"
                          "gnome-themes-extra"
                          "nordic-theme"
                          "lxappearance"
                          "font-google-noto"
                          "font-google-noto-serif-cjk"
                          "font-google-noto-sans-cjk"

                          "zstd"
                          "unzip"

                          "btop"
                          "hyprcursor"
                          "vlc"
                          "waybar"
                          "mako"
                          "firefox"
                          "syncthing"
                          "keepassxc")))))
