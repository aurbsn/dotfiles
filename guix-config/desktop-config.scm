(use-modules (gnu)
	     (base-system)
             (gnu packages gnome)
             (gnu packages networking)
	     (nongnu system linux-initrd)
	     (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu services nvidia))
(use-service-modules cups desktop networking ssh xorg dbus nix)

(operating-system
 (inherit base-operating-system)
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
                     (delete gdm-service-type)
                     (guix-service-type config => 
                                        (guix-configuration
                                         (inherit config)
                                         (substitute-urls
                                          (append (list "https://substitutes.nonguix.org")
                                                  %default-substitute-urls))
                                         (authorized-keys
                                          (append (list (local-file "./signing-key.pub"))
                                                  %default-authorized-guix-keys))))))))
