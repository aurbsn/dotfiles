(define-module (arbn systems arbn-desktop)
  #:use-module (gnu)
  #:use-module (arbn systems base-system)
  #:use-module (arbn modules service-lists)
  #:use-module (arbn modules package-lists)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages chrome)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages mozilla)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu packages game-client)
  #:use-module (gnu home)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop))
(use-service-modules cups desktop networking ssh xorg dbus)
(use-package-modules wm linux xdisorg package-management terminals
             freedesktop networking gnome audio pulseaudio curl
             xorg ssh games gnome-xyz fonts compression admin
             video syncthing password-utils glib emacs-xyz fcitx5 vulkan
             gcc)

(system-config
 #:system
 (operating-system
  (kernel-arguments '("modprobe.blacklist=nouveau"
                      "nvidia_drm.modeset=1"))

  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (keyboard-layout (keyboard-layout "us"))
  (host-name "arbn-desktop")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))
               (keyboard-layout keyboard-layout)
               (menu-entries (list (menu-entry
                                (label "Ubuntu")
                                (linux "/boot/vmlinuz")
                                (linux-arguments '("root=/dev/nvme0n1p3"))
                                (initrd "/boot/initrd.img"))))))

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
  (packages
   (map replace-mesa
    (append
     (list hyprland
           xdg-desktop-portal-hyprland
           xdg-desktop-portal-gtk
           alacritty
           wofi
           flatpak
           blueman
           bluez
           bluez-alsa
           pulseaudio
           curl
           setxkbmap)
     %base-system-packages))))
 #:home
 (home-environment 
  (services
   (create-home-services
    (list ; System-specific home services
     (service home-syncthing-service-type)
     (service home-pipewire-service-type)
     (service home-dbus-service-type))

    ; System-specific home configuration files
    (list 
     `("bin/wrappedhl.sh"
       ,(local-file "../../config-files/wrappedhl.sh"))
     `(".config/waybar/config"
       ,(local-file "../../config-files/waybar/conf"))
     `(".config/hypr/hyprland.conf"
       ,(local-file "../../config-files/hyprland.conf")))))
  (packages
   (map replace-mesa
        (append 
         %desktop-home-packages
         (list 
          dconf

          gnome-themes-extra
          nordic-theme
          font-google-noto
          font-google-noto-serif-cjk
          font-google-noto-sans-cjk
          
          zstd
          unzip

          btop
          hyprcursor
          vlc
          waybar
          mako
          firefox
          syncthing
          keepassxc
     
          ; IME
          emacs-rime
          fcitx5-rime
          )))))
 #:my-system-services
 (append 
  (list
   (service nvidia-service-type
            (nvidia-configuration
             (module nvidia-module-open)))
   (service cups-service-type)
   (service bluetooth-service-type
            (bluetooth-configuration
             (auto-enable? #t)))
   (let ((keyboard-layout (keyboard-layout "us")))
     (set-xorg-configuration
      (xorg-configuration
       (modules (cons nvda %default-xorg-modules))
       (drivers '("nvidia"))
       (keyboard-layout keyboard-layout)))))
  (modify-services 
   (create-system-services %desktop-services)
   (gdm-service-type config =>
                     (gdm-configuration
                      (inherit config)
                      (wayland? #t)))
   (dbus-root-service-type config => 
                           (dbus-configuration (inherit config)
                                               (services (list blueman)))))))
