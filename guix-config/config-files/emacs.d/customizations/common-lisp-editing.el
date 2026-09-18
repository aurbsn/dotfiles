(when (locate-library "aggressive-indent")
  (add-hook 'lisp-mode-hook #'aggressive-indent-mode))

(use-package sly-repl-ansi-color
  :after sly)

(use-package sly-asdf
  :after sly)

(when (locate-library "sly")
  (add-hook 'lisp-mode-hook #'sly-editing-mode))
