
(require 'erc-join)             ; autojoin support is implemented by erc-join.el
(erc-autojoin-enable)           ; enable channel autojoin support, by default
(setq erc-server "irc.libera.chat"
      erc-nick "arbn"
      erc-user-full-name "arbn"
      erc-track-shorten-start 8
      erc-autojoin-channels-alist '(("libera.chat" "#systemcrafters" "#emacs" "#stumpwm" "#lisp" "#gnu" "#erc" "#guix" "#guile"))
      erc-kill-buffer-on-part t
      erc-auto-query 'bury)
