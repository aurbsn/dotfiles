;; -*-lisp-*-

(in-package :stumpwm)

;; Swank
(require :swank)
(ignore-errors
  (swank-loader:init)
  (swank:create-server :port 4004
                       :style swank:*communication-style*
                       :dont-close t))

(set-prefix-key (kbd "C-z"))
(setf (getenv "PATH") (concat "/home/arbn/bin:" (getenv "PATH")))

;; Message and input bar
(require :clx-truetype);
(require :ttf-fonts)
(setf xft:*font-dirs* '("~/.guix-home/profile/share/fonts"))
(xft:cache-fonts)
(set-font (make-instance 'xft:font :family "Source Code Pro" :subfamily "Regular" :size 18))
(set-fg-color "#ACE6D7")
(set-border-color "#ACE6D7")
(setf *message-window-gravity* :top-left
      *input-window-gravity* :top-left
      *window-border-style* :none)

(defcommand volume-up () ()
    (run-shell-command "amixer -q sset Master 3%+"))

(defcommand volume-down () ()
    (run-shell-command "amixer -q sset Master 3%-"))

(defcommand volume-mute () ()
    (run-shell-command "amixer -q sset Master toggle"))

; Key bindings
(define-key *top-map* (kbd "XF86AudioLowerVolume") "volume-down")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "volume-up")
(define-key *top-map* (kbd "XF86AudioMute")        "volume-mute")

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
(run-shell-command "fcitx5 &")
(run-shell-command "setxkbmap -option ctrl:nocaps" t)
(run-shell-command "syncthing &")
(run-shell-command "/home/arbn/dev/dotfiles/guix-config/config-files/docked.sh" t)
(mode-line)
