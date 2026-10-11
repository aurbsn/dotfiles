;; -*- lexical-binding: t; -*-
(use-package sly-repl-ansi-color
  :after sly)

(use-package sly-asdf
  :after sly)

(use-package sly-macrostep
  :after sly)

(setq sly-lisp-implementations
      '((sbcl ("sbcl"))))

(use-package clhs
  :if (locate-library "clhs")
  :config
  (clhs-setup))
