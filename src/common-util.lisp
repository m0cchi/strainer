(in-package :cl-user)

(defpackage strainer.common-util
  (:use :cl)
  (:import-from :flexi-streams
                :string-to-octets)
  (:import-from :cl-fad
                :directory-exists-p
                :list-directory)
  (:export :file-path-to-uri :search-files :size-of-string))

(in-package :strainer.common-util)

(defun size-of-string (string)
  (length (string-to-octets string)))

(defun search-files (path)
  (let* ((all (list-directory path))
         (files (remove-if #'directory-exists-p all))
         (dirs (remove-if-not #'directory-exists-p all)))
    (loop for dir in dirs while dir do
          (setq files (append files (search-files dir))))
    files))

(defun file-path-to-uri (file-p base-len)
  (let ((path-string (namestring file-p)))
    (format nil "/~a" (subseq path-string base-len (size-of-string path-string)))))
