(define-module (arbn systems base-system)
  #:use-module (gnu)
  #:use-module (srfi srfi-1)
  #:use-module (gnu system locale))
(use-package-modules package-management terminals xdisorg freedesktop)
(use-service-modules cups desktop networking ssh xorg avahi dbus sound pm)

(define-public base-operating-system
)

(define* (system-config #:key system home)
  (operating-system
   (inherit system)
   
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us"))

   (locale-definitions 
    (list 
     (locale-definition 
      (name "en_US.utf8") (source "en_US"))
     (locale-definition 
      (name "zh_CN.utf8") (source "zh_CN"))))

   ;; Use the UEFI variant of GRUB with the EFI System
   ;; Partition mounted on /boot/efi.
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))
                (keyboard-layout keyboard-layout)))

   (users (cons* (user-account
                  (name "arbn")
                  (group "users")
                  (home-directory "/home/arbn")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video")))
                 %base-user-accounts))
   (packages
    (cons* 
     mg
     git
     exfat-utils
     fuse-exfat
     gvfs ;; Enable user mounts
     %base-packages))
   
   (services 
    (append 
     (service guix-home-service-type
              `(("arbn" ,home)))
     (modify-services 
      %base-services
      (guix-service-type config => 
                         (guix-configuration
                          (inherit config)
                          (substitute-urls
                           (append (list "https://substitutes.nonguix.org")
                                   %default-substitute-urls))
                          (authorized-keys
                           (append (list (local-file "./signing-key.pub"))
                                   %default-authorized-guix-keys)))))))))
