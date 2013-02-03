(add-to-list 'load-path "~/.emacs.d/lisp/") ; quack.el and other elisp modules go in here.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes") ; directory for custom themes.
(setq exec-path (append exec-path "/usr/local/bin/")) ; For loading binaries (like mit-scheme)
(require 'quack)
(setq quack-default-program "mit-scheme") ; Interpreter for SICP exercise code.
(load "~/.emacs.d/lisp/haskell-mode/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(defun make-backup-file-name (file) ; Backup file directory
  (concat “~/.emacs_backups/” (file-name-nondirectory file) “~”))
(load-theme 'solarized-light t)
(setq column-number-mode t)
