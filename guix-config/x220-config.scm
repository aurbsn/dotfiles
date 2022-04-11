;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "lisp-machine")
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
     (map specification->package 
          (list "nss-certs"
                "fontconfig"
	        "font-dejavu"
                "font-gnu-freefont"
                "font-ghostscript"
                "glibc-locales"

                ;; X Settings Manager
                "xsettingsd"))
      %base-packages))
  (services %desktop-services)
  (bootloader
    (bootloader-configuration
      (bootloader grub-bootloader)
      (target "/dev/sda")
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
