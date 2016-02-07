(in-package :cl-user)

(defpackage strainer.common-util
  (:use :cl)
  (:import-from :flexi-streams
                :string-to-octets)
  (:export :respond :respond-with-file))

(in-package :strainer.common-util)

(defun string-size-in-octets (string)
  (length (string-to-octets string)))

