(define-module (arbn systems arbn-dev)
  #:use-module (gnu)
  #:use-module (arbn systems base-system)
  #:use-module (arbn modules service-lists)
  #:use-module (arbn modules package-lists)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nongnu packages chrome)
  #:use-module (nongnu packages linux)
  #:use-module (gnu home)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop))
(use-service-modules desktop networking ssh xorg syncthing dbus security-token)
(use-package-modules audio curl networking pulseaudio linux wm xorg gnome web-browsers security-token package-management)

(define host-name "arbn-dev")

(system-config
 #:system
 (operating-system
   (host-name host-name)
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))

   (keyboard-layout (keyboard-layout "us"))

   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets '("/boot/efi"))
     (keyboard-layout keyboard-layout)))

   (mapped-devices
    (list (mapped-device
           (source
            (uuid "fc54a5db-be89-4f94-a8f5-ff92207f9216"))
           (target "system-root")
           (type luks-device-mapping))))

   (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "A856-C5A4"
                           'fat32))
             (type "vfat"))
	   (file-system
             (mount-point "/")
             (device "/dev/mapper/system-root")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems))
   
   (packages
    (append (list
             gnome-tweaks
             gnome-shell-extensions)
            %base-system-packages)))
 #:home
 (home-environment 
  (services
   (create-home-services 
    (list
     (service home-syncthing-service-type)
     (service home-pipewire-service-type)
     (service home-dbus-service-type))
    '()
    #:free #f))
  (packages
   (append
    (list flatpak)
    %desktop-home-packages)))
 #:my-system-services
 (modify-services
     (create-system-desktop-services 
      (append 
       (list
        (service gnome-desktop-service-type))
       %yubikey-services
       %desktop-services)
      #:free #f)
   (gdm-service-type config => (gdm-configuration
                                (wayland? #t)))
   (bluetooth-service-type config => (bluetooth-configuration
                                      (name host-name)))))
