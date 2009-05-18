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
   :iolib
   :host "0.0.0.0"
   :port 9999))

(defclass knight-server (standard-server)
  ())

(defun make-ktour-server ()
  (make-instance
   'knight-server
   :backend (make-serve)))

(defvar *ktour-server* (make-ktour-server))

(defclass ktour-application (basic-application static-roots-application-mixin)
  ()
  (:default-initargs
   :url-prefix "/"
    :static-roots (list (cons "" #P "/home/fade/SourceCode/lisp/kinsasha/"))))

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
  (ucw-core::remove-expired-sessions *ktour-application*)
  (<:H1 "Knight's Tour Solutions Incorporated!")
  (<:pre (format (html-stream (context.response *context*))
		  (print-board (knights-tour)))))

(defentry-point "board.ucw" (:application *ktour-application*)
  ()
  (call 'ktour-display))

(defcomponent ktour-display (standard-window-component)
  ()
  (:default-initargs
      :body (make-instance 'ktour-component-board)))

(defcomponent ktour-component-board ()
  ())

(defun giver (arr rank col &key colour)
  (let ((whichone (aref arr rank col)))
    (if colour
	(format nil "images/~Ar.png" whichone)
	(format nil "images/~Ab.png" whichone))))

(defmethod render ((self ktour-component-board))
  (<:H1 "Knight's Tour Solutions Inc.!")
  (let* ((bboard (knights-tour))
	 (width (* (array-dimension bboard 1) 100)))
    (ucw-core::remove-expired-sessions *ktour-application*)
    (<:table :width width
	     (<:td (dotimes (i (array-dimension bboard 0) nil)
		     (<:tr
		      (dotimes (j (array-dimension bboard 1))
			(if (= (mod (+ i j) 2) 0)
			    (<:td (<:img :width 100 :src (giver bboard i j :colour t)))
			    (<:td (<:img :width 100 :src (giver bboard i j)))
			    ))))))))

;; (defmethod render ((self ktour-component-board))
;;   (<:H1 "Knight's Tour Solutions Inc.!")
;;   (let* ((bboard (knights-tour)))
;;     (<:td (dotimes (i (array-dimension bboard 0) nil)
;; 	    (<:tr
;; 	     (dotimes (j (array-dimension bboard 1))
;; 	       (cond ((and (evenp i) (oddp j)) (<:td (<:img :src (giver bboard i j :colour t))))
;; 		     ((and (oddp i) (evenp j)) (<:td (<:img :src (giver bboard i j)))))))))))

