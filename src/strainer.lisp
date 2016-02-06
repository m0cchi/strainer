(in-package :cl-user)

(defpackage strainer
  (:use :cl)
  (:import-from :woo
                :run)
  (:export :register-route :defroute :defroutes :search-route :start))

(in-package :strainer)

(defvar *routes* '())
(defvar *404* `(:method 
                ,(lambda (env)
                   '(404 (:content-type "text/plain") ("404 NotFound")))))

(defun register-route (route)
  (let* ((method (getf route :method))
         (func (coerce method 'function)))
    (setf (getf route :method) func)
    (push route *routes*)))

(defun defroute- (route)
  (let* ((method-type (nth 0 route))
         (path (nth 1 route))
         (method (nth 2 route)))
    `(:method-type ,method-type
      :path ,path
      :method (lambda (env)
                (declare (ignorable env)) ,method))))

(defmacro defroute (route)
  `(register-route (quote ,(defroute- route))))

(defmacro defroutes (&rest routes)
  (let ((route- '()))
    (loop for route in routes while route
          do (push `(register-route (quote ,(defroute- route))) route-))
    (append '(progn) route-)))

(defun search-route (method-type path)
  (let ((route (remove-if-not #'(lambda (route)
                                  (and (equal (getf route :path)
                                              path)
                                       (equal (getf route :method-type)
                                              method-type)))
                              *routes*)))
    (or (car route) *404*)))

(defun execute (env)
  (let* ((method-type (getf env :request-method))
         (path (getf env :path-info)))
    (funcall (getf (search-route method-type path) :method) env)))


(defun start (&key (port 5000) (address "0.0.0.0") (worker-num nil))
  (run #'execute :port port :address address :worker-num worker-num))
