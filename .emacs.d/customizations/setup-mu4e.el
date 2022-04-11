;; example configuration for mu4e

;; make sure mu4e is in your load-path
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

(setq mu4e-sent-folder   "/sent")
(setq mu4e-drafts-folder "/drafts")
(setq mu4e-trash-folder  "/trash")

(setq mu4e-maildir "~/mail"
      mu4e-attachment-dir "~/downloads")

(setq user-mail-address "arbn@arbn.nyc"
      user-full-name  "Austin Robinson")

;; Get mail
(setq mu4e-get-mail-command "mbsync protonmail"
      mu4e-change-filenames-when-moving t   ; needed for mbsync
      mu4e-update-interval 120)             ; update every 2 minutes

;; Send mail
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-auth-credentials "~/.authinfo.gpg"
      smtpmail-smtp-server "127.0.0.1"
      smtpmail-stream-type 'starttls
      smtpmail-smtp-service 1025)

;(add-to-list 'gnutls-trustfiles (expand-file-name "~/.config/protonmail/bridge/cert.pem"))
