(define-module (arbn systems hackpad)
  #:use-module (gnu)
  #:use-module (arbn systems base-system)
  #:use-module (arbn modules service-lists)
  #:use-module (arbn modules package-lists)
  #:use-module (arbn modules wireguard)
  #:use-module (gnu home))
(use-service-modules desktop linux networking pm ssh xorg)
(use-package-modules audio curl networking pulseaudio linux wm xorg)

(define %desktop-build-machine
  #~(build-machine
     (name #$(node-address "arbn-desktop"))
     (systems (list "x86_64-linux" "i686-linux"))
     (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfjShm8Sq2rFedqwDfjysYGL92z2J/my51+TcexFIjv")
     (user "arbn")
     (private-key "/root/.ssh/id_ed25519")))

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
          (type luks-device-mapping)
          (arguments '(#:allow-discards? #t)))))

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
            curl)
           %base-system-packages)))
 #:home
 (home-environment 
  (services
   (create-home-services 
    '() 
    '()
    #:free #t))
  (packages
   %desktop-home-packages))
 #:my-system-services
 (create-system-services 
 (append 
  (list
   (service gnome-desktop-service-type)
   (wireguard-client-service "hackpad")
   (service tlp-service-type)
   (service thermald-service-type)
   (service fstrim-service-type))
  (modify-services
   %desktop-services
   (gdm-service-type config => (gdm-configuration
             (wayland? #t)))
   (guix-service-type config => (guix-configuration
                                 (inherit config)
                                 (build-machines
                                  (list %desktop-build-machine))
                                 (authorized-keys
                                  (cons (local-file "../../signing-keys/arbn-desktop.pub")
                                        (guix-configuration-authorized-keys
                                         config)))))))
 #:free #t))
