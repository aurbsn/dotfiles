(define-module (arbn systems base-system)
  #:use-module (gnu)
  #:use-module (srfi srfi-1)
  #:use-module (gnu system locale)
  #:use-module (arbn modules service-lists)
  #:export (system-config))
(use-service-modules guix)

(define* (system-config #:key system my-system-services home)
  (operating-system
   (inherit system)
   
   (locale "en_US.utf8")
   (timezone "America/New_York")

   (locale-definitions 
    (list 
     (locale-definition 
      (name "en_US.utf8") (source "en_US"))
     (locale-definition 
      (name "zh_CN.utf8") (source "zh_CN"))))

   (users (cons* (user-account
                  (name "arbn")
                  (group "users")
                  (home-directory "/home/arbn")
                  (supplementary-groups
                   '("wheel" "netdev" "audio" "video")))
                 %base-user-accounts))

   (services
    (append
     (list
      (service guix-home-service-type
               `(("arbn" ,home))))
     my-system-services))))
