;;;; ***********************************************************************
;;;;
;;;; Name:          sequences.lisp
;;;; Project:       net.bardcode.sequences
;;;; Purpose:       handy sequence utilities
;;;; Author:        mikel evins
;;;; Copyright:     2021 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:net.bardcode.sequences)


;;; (cat sequence1 sequence2) => sequence3
;;; ---------------------------------------------------------------------

(defmethod cat ((left null) (right null) &key type &allow-other-keys) nil)
(defmethod cat ((left sequence) (right null) &key type &allow-other-keys) left)
(defmethod cat ((left null) (right sequence) &key type &allow-other-keys) right)

(defmethod cat ((left list) (right list) &key type &allow-other-keys)
  (cl:append left right))

(defmethod cat ((left sequence) (right sequence) &key class &allow-other-keys)
  (let ((class (or class (class-of left))))
    (concatenate class left right)))


;;; (empty? sequence) => Boolean
;;; ---------------------------------------------------------------------

(defmethod empty? ((sequence cl:null) &key &allow-other-keys) t)
(defmethod empty? ((sequence cl:sequence) &key &allow-other-keys)(cl:zerop (cl:length sequence)))


;;; (filter predicate sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod filter (predicate (sequence cl:null)) 
  (declare (ignore predicate))
  nil)

(defmethod filter (predicate (sequence cl:sequence))
  (cl:remove-if-not predicate sequence))


;;; (interleave sequence1 sequence2) => sequence3
;;; ---------------------------------------------------------------------

(defmethod interleave ((sequence1 cl:null)(sequence2 cl:null)) nil)
(defmethod interleave ((sequence1 cl:null)(sequence2 cl:cons)) nil)
(defmethod interleave ((sequence1 cl:null)(sequence2 cl:vector)) nil)

(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:null)) nil)

(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:cons)) 
  (loop for x in sequence1 for y in sequence2 append (list x y)))

(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:vector)) 
  (loop for x in sequence1 for y across sequence2 append (list x y)))

(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:null)) (cl:vector))

(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:cons)) 
  (interleave sequence1 (as 'cl:vector sequence2)))

(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:vector)) 
  (cl:coerce (loop for x across sequence1 for y across sequence2 append (list x y))
             'cl:vector))

(defmethod interleave ((sequence1 cl:string)(sequence2 cl:string)) 
  (cl:coerce (loop for x across sequence1 for y across sequence2 append (list x y))
             'cl:string))


;;; (interpose item sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod interpose (item (sequence cl:null))
  (declare (ignore item sequence))
  nil)

(defmethod interpose (item (sequence cl:cons)) 
  (if (null (cdr sequence))
      sequence
      (cons (car sequence)
        (cons item
              (interpose item (cdr sequence))))))

(defmethod interpose (item (sequence cl:vector)) 
  (let ((len (cl:length sequence)))
    (case len
      ((0 1) sequence)
      (t (let ((result (make-array (1- (* 2 len)) :initial-element item)))
           (loop for i from 0 below len 
              do (setf (elt result (* i 2))
                       (elt sequence i)))
           result)))))

(defmethod interpose ((item character) (sequence cl:string)) 
  (let ((len (cl:length sequence)))
    (case len
      ((0 1) sequence)
      (t (let ((result (make-string (1- (* 2 len)) :initial-element item)))
           (loop for i from 0 below len 
              do (setf (elt result (* i 2))
                       (elt sequence i)))
           result)))))


;;; (join cupola sequences) => sequence
;;; ---------------------------------------------------------------------

(defun join (cupola sequences)
  (reduce 'cat (interpose cupola sequences)))

