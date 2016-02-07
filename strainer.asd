#|
URL: https://github.com/mocchit/http-ink
Author: mocchit
|#

(in-package :cl-user)
(defpackage strainer-asd
  (:use :cl :asdf))
(in-package :strainer-asd)

(defsystem strainer
  :version "0.0.1"
  :author "mocchi"
  :license "BSD License"
  :depends-on (:flexi-streams
               :trivial-mimes
               :uiop
               :local-time
               :woo)
  :components ((:module "src"
                        :components
                ((:file "util")
                 (:file "strainer")
                 (:file "common-util"))))
  :description "web application framework")
