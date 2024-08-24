(use-modules (gnu)
	     (base-system)
	     (nongnu system linux-initrd)
	     (nongnu packages linux)
             (nongnu packages nvidia)
             (nongnu services nvidia))
(use-service-modules cups desktop networking ssh xorg)

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
                    (service nvidia-service-type)
                    ;; Configure desktop environment, GNOME for example.
                    (service gnome-desktop-service-type)
                    ;; Configure Xorg server, only do this when the card is used for
                    ;; displaying.
                    (set-xorg-configuration
                     (xorg-configuration
                      (modules (cons nvda %default-xorg-modules))
                      (drivers '("nvidia"))))

                    (service cups-service-type)
                    (set-xorg-configuration
                     (xorg-configuration (keyboard-layout keyboard-layout)))
                    (service bluetooth-service-type))

                   ;; This is the default list of services we
                   ;; are appending to.
                   (modify-services %desktop-services
                                    (guix-service-type config => 
                                                       (guix-configuration
                                                        (inherit config)
                                                        (substitute-urls
                                                         (append (list "https://substitutes.nonguix.org")
                                                                 %default-substitute-urls))
                                                        (authorized-keys
                                                         (append (list (local-file "./signing-key.pub"))
                                                                 %default-authorized-guix-keys))))))))
