(defpackage #:hello-world-client
  (:use #:cl)
  (:export #:call-hello-world)
  (:local-nicknames
   (#:hwp #:cl-protobufs.hello-world)))

(in-package #:hello-world-client)

(defvar *address* "http://localhost")

(defvar *port* "4242")

(defvar *handler* "hello")

(defun call-hello-world (&key name
                           (address *address*)
                           (port *port*)
                           (handler *handler*))
  (declare (type (or null string) name))
  (let* ((proto-to-send
           (if name
               (hwp:make-request :name name)
               (hwp:make-request)))
         (address (concatenate 'string address ":" port "/" handler))
         (response
           (cl-protobufs:deserialize-from-bytes
            'hwp:response
            (drakma:http-request
             address
             :content-type "application/octet-stream"
             :content (cl-protobufs:serialize-to-bytes proto-to-send)))))
    (print
     (hwp:response.response response))))
