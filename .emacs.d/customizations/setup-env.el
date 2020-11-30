(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))

(let ((this-env (get-string-from-file "~/.emacs.d/env")))
  (cond
   ((eq this-env "etsy") (load "setup-etsy.el")
    )))
