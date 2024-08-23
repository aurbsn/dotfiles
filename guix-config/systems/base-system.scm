(define-module (base-system)
  #:use-module (gnu)
  #:use-module (srfi srfi-1)
  #:use-module (gnu system locale))
(use-service-modules cups desktop networking ssh xorg avahi dbus sound pm)

(define %xorg-libinput-config
  "Section \"InputClass\"
  Identifier \"Touchpads\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsTouchpad \"on\"

  Option \"Tapping\" \"on\"
  Option \"TappingDrag\" \"on\"
  Option \"DisableWhileTyping\" \"on\"
  Option \"MiddleEmulation\" \"on\"
  Option \"ScrollMethod\" \"twofinger\"
EndSection
Section \"InputClass\"
  Identifier \"Keyboards\"
  Driver \"libinput\"
  MatchDevicePath \"/dev/input/event*\"
  MatchIsKeyboard \"on\"
EndSection
")

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
    (append
     (map specification->package 
          (list 
		"xorg-server"
		"xinit"
                "fontconfig"
	        "font-dejavu"
                "font-gnu-freefont"
                "font-ghostscript"
                "glibc-locales"
		
                ;; X Settings Manager
                "xsettingsd"
                "xf86-input-libinput"
                "mg"
                "git"

                ;; other
                "curl"
                "setxkbmap"
                "openssh"
                ))
     %base-packages))

  (services
   (append (list (service gnome-desktop-service-type)
                 (service cups-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

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
                                               %default-authorized-guix-keys)))))))))

