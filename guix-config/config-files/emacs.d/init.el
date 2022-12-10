;; Define package repositories
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
;; Performance tweaks
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq package-native-compile t)

(add-to-list 'load-path "~/.emacs.d/vendor")
(add-to-list 'load-path "~/.guix-home/profile/share/emacs/site-lisp")
(add-to-list 'load-path "/usr/share/emacs/site-lisp")
(add-to-list 'load-path "~/.guix-home/profile/share/emacs/site-lisp")
(let ((default-directory "~/.guix-home/profile/share/emacs/site-lisp"))
  (if (file-exists-p default-directory)
      (normal-top-level-add-subdirs-to-load-path)))

;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

(customize-set-variable 'package-selected-packages
  '(;; Flycheck
    flycheck

    ;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit
    rainbow-delimiters

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; PHP mode
    php-mode

    ;; Company PHP
    company-php

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; SLIME for Common LISP
    slime
    slime-company

    ;; The preferred color scheme
    cyberpunk-theme

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit

    ;; Source tree viewer
    neotree

    ;; Auto-complete
    company

    ;; Web mode
    web-mode

    ;; Haskell
    haskell-mode

    ;; Scala
    scala-mode

    ;; Rust
    rust-mode

    ;; Fead reader
    elfeed

    ;; Dependency for conditional installs
    use-package

    ;; EPUB reader
    nov

    ;; View and annotate PDFs
    pdf-tools

    yasnippet

    ;; Mustache
    mustache-mode

    ;; Elisp libraries
    s
    f

    ;; SICP
    sicp

    ; org-roam
    org-roam

    exec-path-from-shell

    ; guix
    guix

    vterm

    clhs

    eglot
    ))

(package-install-selected-packages)

(add-hook 'after-init-hook #'global-flycheck-mode)

(add-to-list 'load-path "~/.emacs.d/customizations")

;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

(require 'use-package)

;; Config branches based on env string value
(load "setup-env.el")

;; Setup ERC
(load "setup-irc.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; The emacs shell
(load "setup-eshell.el")

;; Langauage-specific
(load "setup-c.el")
(load "setup-js.el")
(load "setup-php.el")
(load "setup-rs.el")
(load "setup-html.el")
(load "setup-css.el")
(load "setup-scala.el")
;; Lisps :)
(load "setup-clojure.el")
(load "elisp-editing.el")
(load "setup-scheme.el")

;; Other
(load "setup-git.el")
(load "setup-org.el")

(setq-default explicit-shell-file-name "/bin/bash")
(setq-default vterm-shell "bash")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("b89a4f5916c29a235d0600ad5a0849b1c50fab16c2c518e1d98f0412367e7f97" "5078e1845735a69b21b5effe083998dc368853320f449530c2616cf70bc3c47b" default))
 '(erc-modules
   '(autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring services stamp track))
 '(erc-prompt-for-nickserv-password t)
 '(ns-alternate-modifier '(:ordinary meta :function alt :mouse alt))
 '(ns-command-modifier 'super)
 '(package-selected-packages
   '(flycheck paredit rainbow-delimiters clojure-mode php-mode company-php clojure-mode-extra-font-locking cider slime slime-company cyberpunk-theme smex projectile rainbow-delimiters tagedit magit neotree company web-mode haskell-mode scala-mode rust-mode elfeed use-package nov pdf-tools yasnippet mustache-mode s f sicp org-roam exec-path-from-shell guix vterm clhs eglot))
 '(safe-local-variable-values
   '((eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (eval let
           ((root-dir-unexpanded
             (locate-dominating-file default-directory ".dir-locals.el")))
           (when root-dir-unexpanded
             (let*
                 ((root-dir
                   (expand-file-name root-dir-unexpanded))
                  (root-dir*
                   (directory-file-name root-dir)))
               (unless
                   (boundp 'geiser-guile-load-path)
                 (defvar geiser-guile-load-path 'nil))
               (make-local-variable 'geiser-guile-load-path)
               (require 'cl-lib)
               (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (eval setq-local guix-directory
           (locate-dominating-file default-directory ".dir-locals.el"))))
 '(tramp-remote-path
   '(tramp-default-remote-path "~/node_modules/.bin" tramp-own-remote-path))
 '(tramp-use-ssh-controlmaster-options nil)
 '(warning-suppress-types '((comp))))
