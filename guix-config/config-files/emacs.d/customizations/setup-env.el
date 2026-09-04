(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

;; Personal vs work separation here
(let ((this-env (get-string-from-file "~/.emacs.d/env")))
  (cond
   ((equal this-env "personal") (load "setup-personal.el"))))
