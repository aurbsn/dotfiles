(require 'slime)
(setq inferior-lisp-program (executable-find "sbcl"))
(require 'slime-autoloads)
(slime-setup '(slime-company))

(add-to-list 'auto-mode-alist (cons "\\.paren\\'" 'lisp-mode))
(add-hook 'lisp-mode-hook
          #'(lambda ()
              (when (and buffer-file-name
                         (string-match-p "\\.paren\\>" buffer-file-name))
                (unless (slime-connected-p)
                  (save-excursion (slime))))))
