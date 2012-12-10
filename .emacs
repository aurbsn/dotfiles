(add-to-list 'load-path "~/.emacs.d/lisp/") ; quack.el and other elisp modules go in here.
(setq exec-path (append exec-path '("/usr/local/bin/"))) ; For loading binaries (like mit-scheme) installed with Homebrew on Mac OS X.
(require 'quack)
(setq quack-default-program "mit-scheme") ; Interpreter for SICP exercise code.
(load "~/.emacs.d/haskell-mode/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
