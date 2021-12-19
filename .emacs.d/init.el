;; Define package repositories
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages nil)
(setq my-packages
  '(;; Flycheck
    flycheck

    ;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; Scheme stuff
    geiser
    geiser-guile

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

    ;; Language Server Protocol
    lsp-mode
    lsp-ui
    lsp-treemacs
    dap-mode

    ;; Mustache
    mustache-mode

    ;; Elisp libraries
    s
    f
    ))

(setq vc-handled-backends nil)

(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'use-package)

;; LSP setup
(require 'lsp-mode)

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
(add-to-list 'load-path "~/.emacs.d/vendor")

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Config branches based on env string value
(load "setup-env.el")

;; Setup ERC
(load "setup-irc.el")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

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

;; Other
(load "setup-git.el")
(load "setup-org.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(erc-modules
   '(autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring services stamp track))
 '(erc-prompt-for-nickserv-password t)
 '(mac-command-modifier 'super)
 '(mac-option-modifier '(:ordinary meta))
 '(package-selected-packages
   '(geiser-guile yasnippet slime pdf-tools mustache-mode web-mode use-package tagedit smex sbt-mode rust-mode rainbow-delimiters projectile paredit nov neotree magit lsp-ui lsp-metals haskell-mode geiser flycheck exec-path-from-shell elfeed cyberpunk-theme company-php clojure-mode-extra-font-locking cider))
 '(tramp-remote-path
   '(tramp-default-remote-path "/bin" "/usr/bin" "/sbin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/opt/bin" "/opt/sbin" "/opt/local/bin" tramp-own-remote-path)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
