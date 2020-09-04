(defpackage #:hello-world-client
  (:use #:cl)
  (:local-nicknames
   (#:hwp #:cl-protobufs.hello-world)))

(in-package #:hello-world-client)

(defvar *address* "http://localhost")

(defvar *port* "4242")

(defvar *handler* "hello")

(defun call-hello-world (name &key (address *address*)
                                (port *port*)
                                (handler *handler*))
  (declare (type (or null string) name))
  (let* ((proto-to-send
           (if name
               (hwp:make-request :name name)
               (hwp:make-request)))
         (serialized-req (cl-protobufs:serialize-object-to-bytes
                          proto-to-send))
         (response
           (drakma:http-request
            (concatenate 'string address ":" port "/" handler)
            :parameters `(("request" . ,(cl-base64:string-to-base64-string
                                         (flexi-streams:octets-to-string
                                          serialized-req))))))
         (bytes (flexi-streams:string-to-octets
                 (cl-base64:base64-string-to-string response))))
    (print
     (hwp:response.response (cl-protobufs:deserialize-object-from-bytes
                             'hwp:response bytes)))))
