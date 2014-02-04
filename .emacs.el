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
                      solarized-theme
                      find-file-in-repository
                      flycheck
                      exec-path-from-shell
                      python-mode))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(add-to-list 'load-path "~/.emacs.d/lisp/ensime/elisp")
(setq column-number-mode t)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)

(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; Scheme
(require 'quack)
(setq quack-default-program "mit-scheme")

;; Haskell
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(put 'narrow-to-region 'disabled nil)

;; Scala
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; Python
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; HTML
(add-hook 'html-mode-hook
          (lambda ()
            ;; Default indentation is usually 2 spaces, changing to 4.
            (set (make-local-variable 'sgml-basic-offset) 4)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))

(load-theme 'solarized-dark)
