(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
 
(defun php-mode-init ()
  "Set some buffer-local variables."
  (setq php-mode-force-pear 1)
  (setq case-fold-search t)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)

  ;; Enable company-mode
  (company-mode t)
  (require 'company-php))

(add-hook 'php-mode-hook 'php-mode-init)
