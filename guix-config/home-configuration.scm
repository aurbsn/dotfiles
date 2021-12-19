;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
  (gnu home)
  (gnu packages)
  (gnu services)
  (guix gexp)
  (gnu home services shells))

(home-environment
  (packages
    (map specification->package
         (list "isync"
               "mu"
               "keepassxc"
               "guile"
               "stumpwm"
               "sbcl"
               "sicp"
               "emacs")))
  (services
    (list (service
            home-bash-service-type
            (home-bash-configuration
              (aliases
                '(("egrep='egrep --color" . "auto")
                  ("fgrep='fgrep --color" . "auto")
                  ("grep='grep --color" . "auto")
                  ("l" . "ls -CF")
                  ("la" . "ls -A")
                  ("ll" . "ls -alF")
                  ("ls='ls --color" . "auto")))
              (bashrc
                (list (local-file
                        "/home/arbn/dev/dotfiles/guix-config/.bashrc"
                        "bashrc")))
              (bash-logout
                (list (local-file
                        "/home/arbn/dev/dotfiles/guix-config/.bash_logout"
                        "bash_logout"))))))))
