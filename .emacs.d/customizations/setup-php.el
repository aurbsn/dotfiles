(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
 
;; TBD if this matches Etsy style
(defun php-mode-init ()
  "Set some buffer-local variables."
  (setq case-fold-search t)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close '0)
  ;; Enable company-mode
  (company-mode t)
  (require 'company-php)

  ;; Enable ElDoc support (optional)
  (ac-php-core-eldoc-setup)

  (set (make-local-variable 'company-backends)
       '((company-ac-php-backend company-dabbrev-code)
         company-capf company-files))
  
  ;; Jump to definition (optional)
  (define-key php-mode-map (kbd "M-]")
    'ac-php-find-symbol-at-point)

  ;; Return back (optional)
  (define-key php-mode-map (kbd "M-[")
    'ac-php-location-stack-back))

(add-hook 'php-mode-hook 'php-mode-init)
