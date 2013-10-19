;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; -*- vtest.lisp -*-
;;;;
;;; this code generates the png tiles used to display numbered
;;; chessboard cells for the kinsasha knight's tour solver

;;; "tbuilder" goes here. Hacks and glory await!
;;;; tbuilder.lisp

(in-package #:tbuilder)

;;; vecto examples, for my own edification.

(defun feedlike-icon (file)
  (with-canvas (:width 100 :height 100)
    (set-rgb-fill 1.0 0.65 0.3)
    (rounded-rectangle 0 0 100 100 10 10)
    (fill-path)
    (set-rgb-fill 1.0 1.0 1.0)
    (centered-circle-path 20 20 10)
    (fill-path)
    (flet ((quarter-circle (x y radius)
             (move-to (+ x radius) y)
             (arc x y radius 0 (/ pi 2))))
      (set-rgb-stroke 1.0 1.0 1.0)
      (set-line-width 15)
      (quarter-circle 20 20 30)
      (stroke)
      (quarter-circle 20 20 60)
      (stroke))
    (rounded-rectangle 5 5 90 90 7 7)
    (set-gradient-fill 50 90
                       1.0 1.0 1.0 0.7
                       50 20
                       1.0 1.0 1.0 0.0)
    (set-line-width 2)
    (set-rgba-stroke 1.0 1.0 1.0 0.1)
    (fill-and-stroke)
    (save-png file)))

(defun radiant-lambda (file)
  (with-canvas (:width 90 :height 90)
    (let ((font (get-font "/usr/share/fonts/truetype/msttcorefonts/times.ttf"))
          (step (/ pi 7)))
      (set-font font 40)
      (translate 45 45)
      (draw-centered-string 0 -10 #(#x3BB))
      (set-rgb-stroke 1 0 0)
      (centered-circle-path 0 0 35)
      (stroke)
      (set-rgba-stroke 0 0 1.0 0.5)
      (set-line-width 4)
      (dotimes (i 14)
        (with-graphics-state
	    (rotate (* i step))
          (move-to 30 0)
          (line-to 40 0)
          (stroke)))
      (save-png file))))

(defun star-clipping (file)
  (with-canvas (:width 800 :height 800)
    (let ((size 100)
          (angle 0)
          (step (* 2 (/ (* pi 2) 5))))
      (translate size size)
      (move-to 0 size)
      (dotimes (i 5)
        (setf angle (+ angle step))
        (line-to (* (sin angle) size)
                 (* (cos angle) size)))
      (even-odd-clip-path)
      (end-path-no-op)
      (flet ((circle (distance)
               (set-rgba-fill distance 0 0
                              (- 1.0 distance))
               (centered-circle-path 0 0 (* size distance))
               (fill-path)))
        (loop for i downfrom 1.0 by 0.05
              repeat 20 do
              (circle i)))
      (save-png file))))

;; /examples

(defun makesquare (s ch &key colour coords (filename nil))
  (with-canvas (:width s :height s)
    (let ((font (get-font "/usr/local/share/fonts/e/Envy_Code_R.ttf")))
      (if colour
	  (set-rgb-fill 1.0 0.0 0.0)  ;; red
	  (set-rgb-fill 0.0 0.0 0.0)) ;; black
      (if coords
	  (rounded-rectangle (first coords) (second coords)  s s 10 10)
	  (rounded-rectangle 0 0 s s 10 10))
      
      (fill-path)
      (set-font font 40)
      (set-rgb-fill 1.0 1.0 1.0)
      ;;; magic constants are bad, but in this case, appropriate.
      (let ((xspot (round (/ s 2)))
	    (yspot (round (* s .4))))
	(draw-centered-string xspot yspot (format nil "~A" ch)))
      (if filename
	  (save-png filename)))))

(defun on-the-tiles (range imagedir &key (tsize 100))
  (let ((*default-pathname-defaults* (truename imagedir)))
    (loop for i from 1 to range
	  for num = (format nil "~A" i)
	  for rname = (merge-pathnames (format nil "~Ar.png" i))
	  for bname = (merge-pathnames (format nil "~Ab.png" i))
	  :do
	  (progn
	    (makesquare tsize i :colour t :filename rname )
	    (makesquare tsize i :colour nil :filename bname))
	  :finally
	  (return *default-pathname-defaults*))))

(defun display-board (arr cell size &key (size-xy 8))
  (let* ((board (* size size-xy)) ;; board size in pixels
	 (barray arr)) 
    (with-canvas (:width board :height board)
      (dotimes (i (array-dimension barray 0) nil))
      )))



