;; Quicklisp
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(load "/home/arbn/quicklisp/clhs-use-local.el" t)

(setq inferior-lisp-program (executable-find "sbcl"))
(require 'slime-autoloads)
(slime-setup '(slime-company))
