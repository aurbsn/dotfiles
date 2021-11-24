;; -*-lisp-*-

(in-package :stumpwm)

(set-prefix-key (kbd "C-z"))

;; Message and input bar
(set-fg-color "#ACE6D7")
(set-border-color "#ACE6D7")
(set-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-15")
(setf *message-window-gravity* :top-left
      *input-window-gravity* :top-left
      )

;;Mode line
(setf *screen-mode-line-format*
      (list 
       '(:eval (run-shell-command "acpi -b" t))
       '(:eval (run-shell-command "date" t)))
      *mode-line-position* :bottom
      *mode-line-background-color* "black"
      *mode-line-foreground-color* "#4c83ff"
      *mode-line-border-color* "#4c83ff"
      )
(mode-line)

