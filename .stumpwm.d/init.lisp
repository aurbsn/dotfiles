;; -*-lisp-*-

(in-package :stumpwm)

;; Swank
(require :swank)
(swank-loader:init)
(swank:create-server :port 4004
                     :style swank:*communication-style*
                     :dont-close t)

(set-prefix-key (kbd "C-z"))

;; Message and input bar
(ql:quickload "clx-truetype")
(load-module "ttf-fonts")
(setf xft:*font-dirs* '("~/.guix-profile/share/fonts"))
;(setf clx-truetype:+font-cache-filename+ (concat (getenv "HOME") "/.fonts/font-cache.sexp"))
(xft:cache-fonts)
(set-font (make-instance 'xft:font :family "Source Code Pro" :subfamily "Regular" :size 22))
(set-fg-color "#ACE6D7")
(set-border-color "#ACE6D7")
(setf *message-window-gravity* :top-left
      *input-window-gravity* :top-left)

;;Mode line
(setf *screen-mode-line-format*
      (list 
       '(:eval (run-shell-command "acpi -b | tr -d '\\n'" t))
       " | "
       '(:eval (run-shell-command "date" t)))
      *mode-line-position* :bottom
      *mode-line-background-color* "black"
      *mode-line-foreground-color* "#4c83ff"
      *mode-line-border-color* "#4c83ff")
(mode-line)

(run-shell-command "setxkbmap -option ctrl:nocaps")
(run-shell-command "nextcloud &")
;(run-shell-command "/home/arbn/.screenlayout/docked.sh")
