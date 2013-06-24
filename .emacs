(require 'package)
(add-to-list `package-archives `("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list `package-archives `("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-bindings
                      starter-kit-eshell
                      clojure-mode
                      clojure-test-mode
		      haskell-mode
		      quack
                      nrepl
                      markdown-mode
                      scala-mode2
                      solarized-theme))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/lisp/ensime/elisp")
(setq column-number-mode t)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)

(load-theme 'solarized-dark)

;; Scheme
(require 'quack)
(setq quack-default-program "mit-scheme")

;; Haskell
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(put 'narrow-to-region 'disabled nil)

;; Objective-C
(defun xcode-build ()
  (interactive)
  (let ((default-directory (up-one-dir buffer-file-name))
        )
    (start-process "xcode-build" "*xcode-build*" "xcodebuild")
    (split-window)
    (switch-to-buffer-other-window "*xcode-build*")))

(defun up-one-dir (file-name)
  (file-name-directory (directory-file-name (file-name-directory file-name))))

;; Scala

(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
