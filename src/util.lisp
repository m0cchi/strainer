(in-package :cl-user)

(defpackage strainer.util
  (:use :cl)
  (:import-from :trivial-mimes
                :mime)
  (:import-from :local-time
                :universal-to-timestamp
                :format-rfc1123-timestring)
  (:import-from :uiop
                :file-exists-p)
  (:export :respond :respond-with-file))

(in-package :strainer-util)

(defun respond (&key (status 200) header body)
  `(,status ,header ,body))

(defun respond-with-file (file)
  (let ((file-p (file-exists-p file))
        (content-type (format nil "~A~:[~;~:*; charset=~A~]"
                              (mime file) "utf-8"))
        (timestamp (format-rfc1123-timestring
                    nil
                    (universal-to-timestamp (get-universal-time)))))
    (with-open-file (stream file-p
                            :direction :input
                            :if-does-not-exist nil)
                    (respond 
                     :header `(:content-type ,content-type
                                            :content-length ,(file-length stream)
                                            :last-modified ,timestamp)
                     :body file-p))))
