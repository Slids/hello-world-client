(defpackage #:hello-world-client
  (:use #:cl)
  (:export #:call-hello-world)
  (:local-nicknames
   (#:hwp #:cl-protobufs.hello-world)
   (#:pu #:protobuf-utilities)))

(in-package #:hello-world-client)

(defvar *address* "http://localhost")

(defvar *port* "4242")

(defvar *handler* "hello")

(defun proto-call (call-name-proto-list return-type address)
  (let* ((call-name-serialized-proto-list
           (loop for (call-name .  proto) in call-name-proto-list
                 for ser-proto = (pu:serialize-proto-to-base64-string proto)
                 collect
                 (cons call-name ser-proto)))
         (call-result
           (or (drakma:http-request
                address
                :parameters call-name-serialized-proto-list)
               "")))
    (pu:deserialize-proto-from-base64-string return-type call-result)))

(defun call-hello-world (name &key (address *address*)
                                (port *port*)
                                (handler *handler*))
  (declare (type (or null string) name))
  (let* ((proto-to-send
           (if name
               (hwp:make-request :name name)
               (hwp:make-request)))
         (address (concatenate 'string address ":" port "/" handler))
         (response (proto-call (list (cons "request" proto-to-send))
                               'hwp:response
                               address)))
    (print
     (hwp:response.response response))))
