(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
 
;; TBD if this matches Etsy style
(defun pear/php-mode-init()
  "Set some buffer-local variables."
  (setq case-fold-search t)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)
)
(add-hook 'php-mode-hook 'pear/php-mode-init)
