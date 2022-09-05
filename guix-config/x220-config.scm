(use-modules (gnu)
             (base-system)
             (nongnu system linux-initrd))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (inherit base-operating-system)
  (initrd microcode-initrd)
  (keyboard-layout (keyboard-layout "us"))
  (host-name "hackpad")
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "35309dd5-dbd2-41d7-92f1-e0cb53ba7ab9"))
            (target "cryptroot")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
