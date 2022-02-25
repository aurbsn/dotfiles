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
  (gnu home services shells)
  (gnu home services desktop))

(home-environment
  (packages
    (map (compose list specification->package+output)
         (list "mu"
               "guile"
               "fontconfig"
               "font-gnu-freefont"
               "font-dejavu"
               "font-ghostscript"
               "glibc-locales"
               "sbcl"
               "acpi"
               "font-adobe-source-code-pro")))
  (services
    (list 
     ; Bash
     (service
      home-bash-service-type
      (home-bash-configuration
       (bashrc
        (list (local-file
               ".bashrc"
               "bashrc")))
       (bash-logout
        (list (local-file
               ".bash_logout"
               "bash_logout")))))
     ; Redshift
     (service
      home-redshift-service-type
      (home-redshift-configuration 
       (location-provider 'geoclue2))))))
