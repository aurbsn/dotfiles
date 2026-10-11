;; -*- lexical-binding: t; -*-
(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode))
(setopt eshell-visual-subcommands '(("git" "log" "diff" "show")))
(setopt eshell-destroy-buffer-when-process-dies 't)

(with-eval-after-load 'esh-module
  (setopt eshell-modules-list
          (seq-union eshell-modules-list
                     '(eshell-smart
                       eshell-elecslash
                       eshell-tramp
                       eshell-xtra))))
