(define-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (srfi srfi-1)
  #:use-module (gnu system locale)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (rosenthal packages wm))
(use-service-modules cups desktop networking ssh xorg avahi dbus sound pm)

(define-public base-operating-system
  (operating-system
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "nobody")

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

    ;; Guix doesn't like it when there isn't a file-systems
    ;; entry, so add one that is meant to be overridden
    (file-systems (cons*
                   (file-system
                     (mount-point "/tmp")
                     (device "none")
                     (type "tmpfs")
                     (check? #f))
                   %base-file-systems))

   (users (cons* (user-account
                  (name "arbn")
                  (group "users")
                  (home-directory "/home/arbn")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video")))
                 %base-user-accounts))
   (packages
    (append (list (replace-mesa hyprland)
                  xdg-desktop-portal-hyprland
                  kitty
                  wofi)
            (append
             (map specification->package 
                  (list 
                   "steam-devices-udev-rules"
                   "fontconfig"
	           "font-dejavu"
                   "font-gnu-freefont"
                   "font-ghostscript"
                   "glibc-locales"
		   
                   ;; X Settings Manager
                   "mg"
                   "git"
                   
                   "blueman"
                   "bluez"
                   "bluez-alsa"
                   "pulseaudio"
                   ;; other
                   "curl"
                   "setxkbmap"
                   "openssh"
                   ))
             %base-packages)))))

