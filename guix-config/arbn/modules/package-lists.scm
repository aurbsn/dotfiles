(define-module (arbn modules package-lists)
  #:use-module (gnu)
  #:use-module (arbn packages emacs))
(use-package-modules 
 base guile package-management text-editors version-control certs lisp lisp-check lisp-xyz 
 emacs emacs-xyz fonts linux rsync guile-xyz cmake ssh scheme education nss books terminals
 tex file-systems)
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

   emacs-minuet

   ; emacs-guru-mode
   ))

(define-public %texlive-packages
  (list texlive-collection-latexrecommended
        texlive-wasysym
        texlive-was
        texlive-wasy
        texlive-lastpage
        texlive-xifthen
        texlive-ifmtarg
        texlive-isodate
        texlive-substr
        texlive-cleveref
        texlive-pgfplots))

; Packages for a personal desktop development environment
(define-public %desktop-home-packages
  (append %base-home-packages
	  %emacs-packages
          %texlive-packages
          (list
           sbcl
           cl-fiveam
           exercism
           rsync
           font-adobe-source-code-pro
           haunt
           book-sicp
           font-adobe-source-han-sans)))

(define-public %base-system-packages ; All systems need these
  (append
   (list
    openssh
    glibc-locales
    mg
    git
    exfat-utils
    efibootmgr
    fuse-exfat)
   %base-packages))
