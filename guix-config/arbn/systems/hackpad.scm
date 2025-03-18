(define-module (arbn systems hackpad)
  #:use-module (gnu)
  #:use-module (arbn systems base-system)
  #:use-module (arbn modules service-lists)
  #:use-module (arbn modules package-lists)
  #:use-module (gnu home))
(use-service-modules desktop networking ssh xorg)
(use-package-modules audio curl networking pulseaudio linux wm xorg)

(system-config
 #:system
 (operating-system
  (host-name "hackpad")

  (keyboard-layout (keyboard-layout "us"))

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
          %base-file-systems))
  
  (packages
   (append (list
            blueman
            bluez
            bluez-alsa
            pulseaudio
            curl
            xorg-server
            xinit)
           %base-system-packages)))
 #:home
 (home-environment 
  (services
   (create-home-services 
    '() 
    (list
     `("dev/start-stump.lisp"
       ,(local-file "../../config-files/start-stump.lisp"))
     `(".xinitrc"
      ,(local-file "../../config-files/xinitrc")))
    #:free #t))
  (packages
   (append
    %desktop-home-packages
    (list 
     cl-stumpwm))))
 #:my-system-services
 (create-system-services %desktop-services #:free #t))
