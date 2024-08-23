(use-modules (gnu)
	     (base-system)
	     (nongnu system linux-initrd)
	     (nongnu packages linux))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
 (inherit base-operating-system)
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
                         (dependencies mapped-devices)) %base-file-systems)))
