
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7d1c7ea4f3e73402f012b7011fc4be389597922fa67ad4ec417816971bca6f9d" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(package-selected-packages
   '(eglot typescript-mode yaml-mode jq-mode helm diminish use-package llama async abyss-theme spacemacs-theme pkg-info a vterm yasnippet web-mode vertico terraform-mode tagedit sly-repl-ansi-color sly-quicklisp sly-asdf sicp rust-mode restclient rainbow-delimiters quelpa projectile php-mode pdf-tools paredit org-roam nov mustache-mode markdown-mode magit kkp haskell-mode guru-mode guix gptel geiser-guile f exec-path-from-shell elfeed cyberpunk-theme counsel corfu consult clojure-mode-extra-font-locking clhs cider aggressive-indent))
 '(safe-local-variable-values
   '((eval progn
           (require 'lisp-mode)
           (defun emacs27-lisp-fill-paragraph
               (&optional justify)
             (interactive "P")
             (or
              (fill-comment-paragraph justify)
              (let
                  ((paragraph-start
                    (concat paragraph-start "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
                   (paragraph-separate
                    (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
                   (fill-column
                    (if
                        (and
                         (integerp emacs-lisp-docstring-fill-column)
                         (derived-mode-p 'emacs-lisp-mode))
                        emacs-lisp-docstring-fill-column fill-column)))
                (fill-paragraph justify))
              t))
           (setq-local fill-paragraph-function #'emacs27-lisp-fill-paragraph))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (geiser-repl-per-project-p . t)
     (eval with-eval-after-load 'yasnippet
           (let
               ((guix-yasnippets
                 (expand-file-name "etc/snippets/yas"
                                   (locate-dominating-file default-directory ".dir-locals.el"))))
             (unless
                 (member guix-yasnippets yas-snippet-dirs)
               (add-to-list 'yas-snippet-dirs guix-yasnippets)
               (yas-reload-all))))
     (eval with-eval-after-load 'tempel
           (if
               (stringp tempel-path)
               (setq tempel-path
                     (list tempel-path)))
           (let
               ((guix-tempel-snippets
                 (concat
                  (expand-file-name "etc/snippets/tempel"
                                    (locate-dominating-file default-directory ".dir-locals.el"))
                  "/*.eld")))
             (unless
                 (member guix-tempel-snippets tempel-path)
               (add-to-list 'tempel-path guix-tempel-snippets))))
     (eval with-eval-after-load 'git-commit
           (add-to-list 'git-commit-trailers "Change-Id"))
     (eval setq-local guix-directory
           (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-to-list 'completion-ignored-extensions ".go"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
