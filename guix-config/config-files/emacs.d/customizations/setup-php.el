(require 'php-mode)
(require 'company-php)

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(php-mode . ("intelephense" "--stdio"))))

(defun php-mode-init ()
  "Set some buffer-local variables."
  (setq case-fold-search t)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)

  ;; Enable company-mode
  (company-mode t)
  )

(add-hook 'php-mode-hook 'php-mode-init)
