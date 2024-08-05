(use-modules (gnu)
	     (base-system)
	     (nongnu system linux-initrd)
	     (nongnu packages linux))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
 (inherit base-operating-system)
 ;(kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (keyboard-layout (keyboard-layout "us"))
 (host-name "arbn-desktop")

 (mapped-devices (list (mapped-device
                        (source (uuid
                                 "42fe484e-c7f2-46a9-935f-056f95d6504a"))
                        (target "cryptroot")
                        (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "323C-FB97"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
