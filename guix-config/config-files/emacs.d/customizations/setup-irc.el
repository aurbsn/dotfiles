;; -*- lexical-binding: t; -*-
(require 'erc-join) ; autojoin support is implemented by erc-join.el
(erc-autojoin-enable) ; enable channel autojoin support, by default
(setq erc-server "irc.libera.chat"
      erc-nick "arbn"
      erc-user-full-name "arbn"
      erc-track-shorten-start 8
      erc-autojoin-channels-alist '(("libera.chat" "#systemcrafters" "#emacs" "#geiser" "#lisp" "#commonlisp" "#erc" "#guix" "#guile" "#clschool" "#scheme" "#clojure" "#sbcl" "#lispcafe" "#racket"))
      erc-kill-buffer-on-part t
      erc-auto-query 'bury
      erc-prompt-for-password nil
      erc-auth-source-password t)

(require 'erc-sasl)
(setq erc-sasl-user :nick          ; use erc-nick
      erc-sasl-password :password  ; look up in auth-source
      erc-sasl-mechanism 'plain    ; or 'scram-sha-256 / 'external
      erc-sasl-authzid nil)
(erc-sasl-mode 1)
