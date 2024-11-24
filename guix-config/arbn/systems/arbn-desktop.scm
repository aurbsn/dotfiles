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
  #:use-module (gnu home services desktop)
  #:use-module (guix-science-nonfree packages cuda)
  #:use-module (rosenthal packages wm))
(use-service-modules cups desktop networking ssh xorg dbus nix)
(use-package-modules wm linux xdisorg package-management terminals
             freedesktop networking gnome audio pulseaudio curl
             xorg ssh games gnome-xyz fonts compression admin
             video syncthing password-utils glib emacs-xyz fcitx5 vulkan
             gcc)

(system-config
 #:system
 (operating-system
  (kernel-arguments '("modprobe.blacklist=nouveau"
                      "clearcpuid=514"
                      "split_lock_detect=off"
                      ;; Set this if the card is not used for displaying or
                      ;; you're using Wayland:
                      "nvidia_drm.modeset=1"))

  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (keyboard-layout (keyboard-layout "us"))
  (host-name "arbn-desktop")

  (bootloader (bootloader-configuration
               (bootloader grub-efi-bootloader)
               (targets '("/boot/efi"))
               (keyboard-layout keyboard-layout)))

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
    (append 
     (list (replace-mesa cuda)
           (replace-mesa hyprland)
           xdg-desktop-portal-hyprland
           xdg-desktop-portal
           xdg-desktop-portal-gtk
           alacritty
           wofi
           (replace-mesa flatpak)
           blueman
           bluez
           bluez-alsa
           pulseaudio
           curl
           setxkbmap
           openssh)
     %base-system-packages)))
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
   (append 
    %desktop-home-packages
    (list 
     (list glib "bin")
     (list gcc "lib")
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
     google-chrome-stable
     syncthing
     keepassxc
     
     ; IME
     emacs-rime
     fcitx5-rime

     steam-nvidia
     steam-devices-udev-rules
     )
    ; GPGPU
    (map replace-mesa
         (list
          vulkan-tools
          vulkan-loader
          vulkan-validationlayers
          spirv-tools
          cuda)))))
 #:my-system-services
 (append 
  (list
   (extra-special-file "/lib64/ld-linux-x86-64.so.2"
	 (file-append glibc "/lib/ld-linux-x86-64.so.2"))
   (service nix-service-type)
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
   (dbus-root-service-type config => 
                           (dbus-configuration (inherit config)
                                               (services (list blueman)))))))
