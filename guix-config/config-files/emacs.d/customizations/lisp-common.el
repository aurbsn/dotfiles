;; -*- lexical-binding: t; -*-

(defconst arbn-lisp-source-hooks
  '(emacs-lisp-mode-hook
    lisp-mode-hook
    scheme-mode-hook
    clojure-mode-hook
    racket-mode-hook)
  "Hooks for modes that edit Lisp source files.")

(defconst arbn-lisp-repl-hooks
  '(lisp-interaction-mode-hook
    ielm-mode-hook
    sly-mrepl-mode-hook
    geiser-repl-mode-hook
    cider-repl-mode-hook
    racket-repl-mode-hook)
  "Hooks for interactive Lisp buffers.")

(defun arbn-add-lisp-hook (fn &optional where)
  "Add fn to Lisp mode hooks. where is `source', `repl', or nil for both."
  (dolist (hook (pcase where
                  ('source arbn-lisp-source-hooks)
                  ('repl arbn-lisp-repl-hooks)
                  (_ (append arbn-lisp-source-hooks arbn-lisp-repl-hooks))))
    (add-hook hook fn)))

(use-package paredit
  :config
  (define-key paredit-mode-map (kbd "RET") nil)
  (define-key paredit-mode-map (kbd "C-j") 'paredit-newline))

(arbn-add-lisp-hook #'enable-paredit-mode)
(arbn-add-lisp-hook #'rainbow-delimiters-mode)

(arbn-add-lisp-hook #'aggressive-indent-mode 'source)

(defun arbn-prettify-lambda ()
  (add-to-list 'prettify-symbols-alist '("lambda" . ?λ))
  (prettify-symbols-mode 1))

(arbn-add-lisp-hook #'arbn-prettify-lambda)

(setq prettify-symbols-unprettify-at-point 'right-edge)
