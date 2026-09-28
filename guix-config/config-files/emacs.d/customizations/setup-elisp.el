;; -*- lexical-binding: t; -*-

;; The M-: minibuffer, which lisp-common.el's mode lists do not cover
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
