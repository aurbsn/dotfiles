;; -*- lexical-binding: t; -*-
;; An Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window. This library works around this problem
;; by copying important environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PATH"))

