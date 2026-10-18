(define-module (arbn modules package-lists)
  #:use-module (gnu)
  #:use-module (arbn packages emacs))
(use-package-modules 
 base guile package-management text-editors version-control certs
 lisp lisp-check lisp-xyz  emacs emacs-xyz fonts linux rsync guile-xyz cmake ssh
 scheme education nss books terminals tex file-systems java gnupg imagemagick
 virtualization hardware file fcitx5 node libcanberra  racket authentication)

;; These packages will always be desired for Guix Home configs, including on servers
(define-public %base-home-packages 
  (list
   git
   nss-certs
   glibc
   glibc-locales
   guile-3.0))

(define-public %emacs-packages
  (list
   emacs-pgtk
   ;; Guix + Guile
   emacs-geiser
   emacs-geiser-guile
   emacs-guix
   ;; Lisp parentheses
   emacs-paredit
   emacs-rainbow-delimiters
   ;; Clojure
   emacs-cider
   emacs-clojure-mode
   ;; Common Lisp
   emacs-aggressive-indent
   emacs-sly
   emacs-sly-asdf
   emacs-sly-macrostep
   emacs-sly-repl-ansi-color
   ;; Racket
   emacs-racket-mode
   ;; LLMs
   emacs-agent-shell
   emacs-gptel
   ;; Document handling
   emacs-nov
   emacs-pdf-tools
   
   ;; Other
   emacs-consult
   emacs-corfu
   emacs-counsel
   emacs-eat
   emacs-ef-themes
   emacs-elfeed
   emacs-exec-path-from-shell
   emacs-guru-mode
   emacs-magit
   emacs-markdown-mode
   emacs-org-roam
   emacs-projectile
   emacs-rainbow-mode
   emacs-restclient
   emacs-tagedit
   emacs-terraform-mode
   emacs-vertico
   emacs-web-mode
   emacs-yaml-mode
   emacs-yasnippet
   emacs-pinentry))

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

;; Packages for a personal desktop development environment
(define-public %desktop-home-packages
  (append %base-home-packages
	  %emacs-packages
          %texlive-packages
          (list
           book-sicp
           sbcl
           racket
           mit-scheme
           exercism
           sbcl-fiveam
           haunt
           font-adobe-source-code-pro
           font-adobe-source-han-sans ; Chinese fonts
           font-adobe-source-han-serif
           font-google-noto-sans-cjk
           font-wqy-zenhei
           font-wqy-microhei)))

;; Desktop packages when not using Guix on a foreign distro
(define-public %desktop-system-home-packages
  (list
   openjdk
   imagemagick
   fcitx5
   fcitx5-chinese-addons
   fcitx5-configtool
   fcitx5-gtk
   fcitx5-qt
   oath-toolkit
   rsync
   mosh
   foot
   binutils))

(define-public %base-system-packages ; All systems need these
  (append
   (list
    openssh
    glibc-locales
    mg
    git
    exfat-utils
    efibootmgr
    fuse-exfat
    swtpm
    tpm2-tools
    file)
   %base-packages))
