(use-package elfeed
  :bind ("C-c w" . elfeed)
  :custom
  (elfeed-db-directory (locate-user-emacs-file "elfeed/"))
  (elfeed-search-filter "@2-weeks-ago +unread")
  (elfeed-feeds
   '(;; Aggregators
     ("https://planet.lisp.org/rss20.xml" lisp cl)
     ("https://planet.scheme.org/atom.xml" lisp scheme)
     ("https://sachachua.com/blog/feed/index.xml" emacs)
     ;; Projects
     ("https://guix.gnu.org/feeds/blog.atom" lisp guix scheme)
     ("https://blog.racket-lang.org/feeds/all.atom.xml" lisp racket)
     ("https://clojure.org/feed.xml" lisp clojure)
     ("https://www.gnu.org/software/guile/news/feed.xml" lisp scheme)
     ;; Lobsters tags
     ("https://lobste.rs/t/lisp.rss" lobsters lisp)
     ("https://lobste.rs/t/clojure.rss" lobsters lisp)
     ("https://lobste.rs/t/logiclangs.rss" lobsters plt)
     ("https://lobste.rs/t/compilers.rss" lobsters compilers)
     ("https://lobste.rs/t/plt.rss" lobsters plt)
     ("https://lobste.rs/t/formalmethods.rss" lobsters plt)
     ("https://lobste.rs/t/emacs.rss" lobsters emacs)))
  :config
  ;; Refresh when opening, not on a timer
  (advice-add 'elfeed :after (lambda (&rest _) (elfeed-update))))
