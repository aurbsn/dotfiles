;; -*- lexical-binding: t; -*-
;; An Emacs instance started from the MacOS graphical user
;; interface will have a different environment than a shell in a
;; terminal window. This library works around this problem
;; by copying important environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(use-package exec-path-from-shell
  :if (eq system-type 'darwin)
  :config
  (exec-path-from-shell-initialize)
  ;; parse-colon-path leaves trailing slashes, which eshell passes on in
  ;; PATH, so anything that finds guix through PATH runs .../bin//guix
  ;; and can't find its pulled profile or channels
  (setq exec-path (mapcar #'directory-file-name exec-path)))

