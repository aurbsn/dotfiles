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
(use-service-modules cups desktop networking ssh xorg dbus avahi lightdm)
(use-package-modules wm linux xdisorg package-management terminals
             freedesktop networking gnome audio pulseaudio curl ssh gnome gnome-xyz fonts compression admin
             video syncthing password-utils emacs-xyz fcitx5 gcc web-browsers xorg display-managers authentication)

(system-config
 #:system
 (operating-system
  (kernel-arguments '("modprobe.blacklist=nouveau"
                      "nvidia_drm.modeset=1"))

  (kernel linux-6.12)
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
         (list 
          gnome-tweaks
          gnome-shell-extensions)
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
    '()))
  (packages
   (map replace-mesa
        (append 
         %desktop-home-packages
         (list 
          unzip

          vlc
          firefox
          keepassxc

          pavucontrol
          yaru-theme

          oath-toolkit

          ; IME
          emacs-rime
          fcitx5-rime
          )))))
 #:my-system-services
 (append 
  (list
   ;; NetworkManager and its applet.
   (service network-manager-service-type
            (network-manager-configuration
             (network-manager (replace-mesa network-manager))))
   (service wpa-supplicant-service-type)    ;needed by NetworkManager
   (simple-service 'network-manager-applet
                   profile-service-type
                   (list (replace-mesa network-manager-applet)))
   (service modem-manager-service-type)
   (service usb-modeswitch-service-type)

   ;; GNOME
   (service lightdm-service-type
            (lightdm-configuration
             (lightdm (replace-mesa lightdm))
             (xorg-configuration
              (xorg-configuration
              (modules (cons nvda %default-xorg-modules))
              (drivers '("nvidia"))
              (keyboard-layout (keyboard-layout "us"))
              (server (replace-mesa xorg-server))))
             (greeters (list
                        (lightdm-gtk-greeter-configuration
                         (lightdm-gtk-greeter (replace-mesa lightdm-gtk-greeter))
                         (assets (map replace-mesa (list adwaita-icon-theme gnome-themes-extra hicolor-icon-theme)))
                         (theme-name "Adwaita-dark")
                         (extra-config '("xft-dpi = 300")))))))
   (service gnome-desktop-service-type
            (gnome-desktop-configuration
             (core-services
              (list
               (replace-mesa gnome-meta-core-services)))
             (shell
              (list (replace-mesa gnome-meta-core-shell)))
             (utilities
              (list (replace-mesa gnome-meta-core-utilities)))
            (extra-packages
             (list (replace-mesa gnome-essential-extras)))))

   ;; The D-Bus clique.
   (service avahi-service-type)
   (service udisks-service-type)
   (service upower-service-type
            (upower-configuration
             (upower (replace-mesa upower))))
   (service accountsservice-service-type)
   (service cups-pk-helper-service-type)
   (service colord-service-type)
   (service geoclue-service-type)
   (service polkit-service-type)
   (service elogind-service-type)
   (service dbus-root-service-type
            (dbus-configuration
             (services (list blueman))))

   ; NVIDIA
   (service nvidia-service-type
            (nvidia-configuration
             (module nvidia-module-open)))
   
   ; Printer
   (service cups-service-type)

   ; Bluetooth
   (service bluetooth-service-type
            (bluetooth-configuration
             (auto-enable? #t))))
  (modify-services
   (create-system-services %base-services))))
