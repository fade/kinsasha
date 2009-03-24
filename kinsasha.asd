;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; -*- kinsasha.asd -*-
;;;;
;;;
;;
;

(defsystem "kinsasha"
    :description "a knights tour solver."
    :version "0.0"
    :author "B.C.J.O"
    :license "junkyard license v19.4 or greater"
    :depends-on (#:ucw
		 #:ktour)
    :components ((:file "kinsasha")))
