;; Quicklisp
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(load "/home/arbn/quicklisp/clhs-use-local.el" t)

;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program (executable-find "sbcl"))
(require 'slime-autoloads)

