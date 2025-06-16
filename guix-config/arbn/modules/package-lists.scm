(define-module (arbn modules package-lists)
  #:use-module (gnu)
  #:use-module (nongnu packages emacs))
(use-package-modules 
 base guile package-management terminals xdisorg freedesktop text-editors 
 version-control file-systems gnome certs lisp lisp-check emacs emacs-xyz fonts 
 linux python rsync lisp-xyz tls guile-xyz python-xyz python-web cmake fonts 
 syncthing ssh scheme education java)

; These packages will always be desired for Guix Home configs,
; include on servers
(define-public %base-home-packages 
  (list
   git
   nss-certs
   glibc
   glibc-locales
   guile-3.0
   libvterm
   cmake))

(define-public %emacs-packages
  (list
   emacs-pgtk
   emacs-vterm

   ; Python
   python-lsp-server

   ; Lisp parentheses
   emacs-paredit
   emacs-rainbow-delimiters

   ; Clojure
   emacs-clojure-mode
   emacs-cider

   ; Common Lisp
   emacs-aggressive-indent
   emacs-sly
   emacs-sly-asdf
   ;emacs-sly-repl-ansi-color

   emacs-spacemacs-theme
   emacs-abyss-theme
   emacs-projectile

   emacs-tagedit

   emacs-magit

   emacs-web-mode

   emacs-use-package

   emacs-nov-el

   emacs-pdf-tools

   emacs-yasnippet

   emacs-org-roam

   emacs-exec-path-from-shell

   emacs-guix
   
   emacs-geiser
   emacs-geiser-guile

   emacs-markdown-mode

   emacs-restclient

   emacs-corfu
   emacs-counsel
   emacs-consult
   emacs-vertico

   emacs-gptel
   emacs-terraform-mode

   emacs-yaml-mode

   emacs-typescript-mode

   ;emacs-eglot

   ;emacs-guru-mode
   ; emacs-kkp
   ; emacs-quelpa
   ))

; Packages for a personal desktop development environment
(define-public %desktop-home-packages
  (append %base-home-packages
	  %emacs-packages
          (list
           sbcl
           cl-fiveam
           exercism
           rsync
           openssl
           font-adobe-source-code-pro

           syncthing
           haunt

           sicp
           clhs

           openjdk
           font-adobe-source-han-sans
           flatpak
           xdg-desktop-portal
           xdg-desktop-portal-gnome)))

(define-public %base-system-packages ; All systems need these
  (append
   (list
    openssh
    glibc-locales
    mg
    git
    exfat-utils
    fuse-exfat)
   %base-packages))
