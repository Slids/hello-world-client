(defsystem :hello-world-client
  :author "Jonathan Godbout"
  :version "0.0.1"
  :licence "MIT-style"
  :description      "CL-protobuf Hello World Client"
  :long-description "CL-protobuf Hello World Client"
  :defsystem-depends-on (:cl-protobufs)
  :depends-on (:drakma)
  :components
  ((:module "src"
    :serial t
    :pathname ""
    :components ((:protobuf-source-file "hello-world")
                 (:file "hello-world-client")))))
