;; -*- lexical-binding: t; -*-
(use-package eat
  :ensure t
  :hook (eshell-load . eat-eshell-mode))
(setq eshell-visual-subcommands '(("git" "log" "diff" "show") ("guix" "search")))
(setq eshell-destroy-buffer-when-process-dies 't)
