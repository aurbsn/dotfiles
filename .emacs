(add-to-list 'load-path "~/.emacs.d/lisp/")
(setq column-number-mode t)

;; Scheme
(require 'quack)
(setq quack-default-program "mit-scheme")

;; Haskell
(load "~/.emacs.d/lisp/haskell-mode/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
