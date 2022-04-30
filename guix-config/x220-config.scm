(use-modules (gnu)
             (base-system))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (inherit base-operating-system)
  (keyboard-layout (keyboard-layout "us"))
  (host-name "lisp-machine")
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (targets '("/dev/sda"))
      (keyboard-layout keyboard-layout)))
  (mapped-devices
    (list (mapped-device
            (source
              (uuid "ddc2afe8-a5d4-47f5-ab49-98d1602769d0"))
            (target "cryptroot")
            (type luks-device-mapping))
          (mapped-device
            (source
              (uuid "94e3794e-81a4-41d7-8402-8e8402e0b221"))
            (target "crypthome")
            (type luks-device-mapping))))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/cryptroot")
             (type "ext4")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/home")
             (device "/dev/mapper/crypthome")
             (type "ext4")
             (dependencies mapped-devices))
           %base-file-systems)))
