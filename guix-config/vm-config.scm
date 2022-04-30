;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix-vm")
  (users (cons* (user-account
                  (name "arbn")
                  (comment "Arbn")
                  (group "users")
                  (home-directory "/home/arbn")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "nss-certs"))
      %base-packages))
  (services
      %desktop-services)
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "e9e77139-bdc4-4ab0-b8b4-1dce535383fa")))
  (file-systems
    (cons* (file-system
             (mount-point "/boot/efi")
             (device (uuid "B50A-80FD" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/")
             (device
               (uuid "337fd89b-08fa-4e83-8519-a66d36dfc0a7"
                     'ext4))
             (type "ext4"))
           %base-file-systems)))
