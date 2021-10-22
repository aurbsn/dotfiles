(require 'php-mode)
(require 'company-php)
(require 'lsp-mode)

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-tramp-connection '("intelephense" "--stdio"))
                  :major-modes '(php-mode)
                  :remote? t
                  :server-id 'intelephense-remote))

(defun php-mode-init ()
  "Set some buffer-local variables."
  (setq php-mode-force-pear 1)
  (setq case-fold-search t)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)
  (setq lsp-enable-file-watchers nil)

  ;; Enable company-mode
  (company-mode t)
  )

(add-hook 'php-mode-hook #'lsp)
(add-hook 'php-mode-hook 'php-mode-init)

