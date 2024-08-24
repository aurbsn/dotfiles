(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/dev/guix"))

(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs "~/dev/guix/etc/snippets"))

(setq user-full-name "Austin Robinson")
(setq user-mail-address "arbn@arbn.nyc")
;; Assuming the Guix checkout is in ~/src/guix.
(if (file-exists-p "~/dev/guix/etc/copyright.el")
    (load-file "~/dev/guix/etc/copyright.el"))
(setq copyright-names-regexp
      (format "%s <%s>" user-full-name user-mail-address))
