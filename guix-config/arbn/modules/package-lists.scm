(define-module (arbn modules package-lists)
  #:use-module (gnu))
(use-package-modules 
 base guile package-management terminals xdisorg freedesktop text-editors 
 version-control file-systems gnome certs lisp lisp-check emacs
 emacs-xyz education rust rust-apps fonts linux)

; These packages will always be desired for Guix Home configs,
; include on servers
(define-public %base-home-packages 
  (list
   git
   nss-certs
   glibc
   (list glibc "static")
   glibc-locales
   guile-3.0
   emacs
   emacs-vterm))

 ; Packages for a personal desktop development environment
(define-public %desktop-home-packages
  (append %base-home-packages
          (list
           xclip
           sbcl
           cl-fiveam
           exercism
           rust
           rust-cargo
           font-adobe-source-code-pro)))

(define-public %base-system-packages ; All systems need these
  (append
   (list
    glibc-locales
    mg
    git
    exfat-utils
    fuse-exfat
    gvfs ;; Enable user mounts
    )
   %base-packages))
