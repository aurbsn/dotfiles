(if (file-exists-p "~/.guix-home/profile")
    (setq package-enable-at-startup nil)
  (progn
    (require 'package)
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
    (setq use-package-always-ensure t)))
