;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; -*- ucwtest.lisp -*-
;;;;


;; (save-lisp-and-die "maxclaims.bin" :executable t
;; 		   :toplevel
;; 		   (lambda ()
;;                      ;;; disable ldb
;; 		     (sb-alien:alien-funcall
;; 		      (sb-alien:extern-alien "disable_lossage_handler" (function sb-alien:void)))
;; 		     (swank:create-server)
;; 		     (maxclaims::startup-maxclaims)
;; 		     (sb-impl::toplevel-init)
;; 		     ))


(defpackage #:kinsasha
  (:use #:cl
	#:ucw
	#:ucw-core
	#:ktour))

(in-package :kinsasha)


(defun make-serve ()
  (ucw::make-backend
   :httpd
;;   :host "coruscant.deepsky.com"
   :port 9999))

(defclass knight-server (standard-server)
  ())

(defun make-ktour-server ()
  (make-instance
   'knight-server
   :backend (make-serve)))

(defvar *ktour-server* (make-ktour-server))

(defclass ktour-application (basic-application)
  ()
  (:default-initargs
   :url-prefix "/"))

(defparameter *ktour-application*
  (make-instance 'ktour-application))

(register-application *ktour-server* *ktour-application*)

(defentry-point "index.ucw" (:application *ktour-application*)
  ()
  (call 'ktour-window))

(defun startup-ktour ()
  (ucw::startup-server *ktour-server*))

(defun shutdown-ktour ()
  (ucw::shutdown-server *ktour-server*))

(defcomponent ktour-window (standard-window-component)
  ()
  (:default-initargs
      :body (make-instance 'ktour-component)))


(defcomponent ktour-component ()
  ())

(defmethod render ((self ktour-component))
  (<:H1 "Knight's Tour Solutions Incorporated!")
  (<:pre (format (html-stream (context.response *context*))
		 (print-board (knights-tour)))))
