;; example configuration for mu4e

;; make sure mu4e is in your load-path
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-get-mail-command "mbsync")

(setq mu4e-sent-folder   "/sent")
(setq mu4e-drafts-folder "/drafts")
(setq mu4e-trash-folder  "/trash")

;; smtp mail setting; these are the same that `gnus' uses.
(setq
   message-send-mail-function   'smtpmail-send-it
   smtpmail-default-smtp-server "127.0.0.1"
   smtpmail-smtp-server         "127.0.0.1"
   smtpmail-local-domain        "127.0.0.1")
