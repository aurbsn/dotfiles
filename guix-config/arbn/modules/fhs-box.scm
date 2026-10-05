(define-module (arbn modules fhs-box)
  #:use-module (guix gexp)
  #:use-module (ice-9 optargs))

(define %fhs-box-packages
  '("node" "bash" "coreutils" "findutils" "grep" "sed" "gawk"
    "diffutils" "patch" "tar" "gzip" "which"
    "git" "ripgrep" "nss-certs"))

;; A persistent FHS container for prebuilt binaries and npm-installed tools.
;;   fhs-box [-m MANIFEST]... [--] [CMD ARGS...]
;; With no CMD, starts an interactive bash.
(define*-public (fhs-box-program #:key (name "fhs-box")
                                 (packages %fhs-box-packages)
                                 (preserve '("^TERM$")))
  (let ((manifest (scheme-file (string-append name "-manifest.scm")
                               #~(specifications->manifest '#$packages))))
    (program-file
     name
     (with-imported-modules
      '((guix build utils))
      #~(begin
          (use-modules (guix build utils) (ice-9 match) (ice-9 receive) (srfi srfi-1))

          (define (parse-args args)
            ;; Return extra manifests and the command to run.
            (let loop ((args args) (manifests '()))
              (match args
                (("-m" file . rest)
                 (loop rest (cons (canonicalize-path file) manifests)))
                (("--" . rest) (values (reverse manifests) rest))
                (rest          (values (reverse manifests) rest)))))

          (receive (manifests command) (parse-args (cdr (command-line)))
            (let* ((home     (getenv "HOME"))
                   (guix     (or (getenv "GUIX")
                                 (string-append home
                                                "/.config/guix/current/bin/guix")))
                   (box-data (string-append home "/.local/share/" #$name)))
              (mkdir-p box-data)
              (apply execl guix guix
                     `("shell" "--container" "--emulate-fhs" "--network"
                       "-m" #$manifest
                       ,@(append-map (lambda (m) (list "-m" m)) manifests)
                       ,(string-append "--share=" home)
                       ,@(map (lambda (re) (string-append "--preserve=" re))
                              '#$preserve)
                       "--" "env"
                       ,(string-append "HOME=" home)
                       ,(string-append "NPM_CONFIG_PREFIX=" box-data "/.local")
                       "SSL_CERT_DIR=/etc/ssl/certs"
                       "sh" "-c"
                       "export PATH=\"$NPM_CONFIG_PREFIX/bin:$PATH\"; exec \"$@\""
                       #$name
                       ,@(if (null? command) '("bash") command))))))))))
