;;;; ***********************************************************************
;;;;
;;;; Name:          net.bardcode.sequences.asd
;;;; Project:       net.bardcode.sequences
;;;; Purpose:       handy sequence utilities
;;;; Author:        mikel evins
;;;; Copyright:     2021 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(asdf:defsystem #:net.bardcode.sequences
  :description "Handy utilities for working with lists and other sequences."
  :author "mikel evins <mikel@evins.net>"
  :license  "Apache 2.0"
  :version "0.0.1"
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "sequences")))))

;;; (ql:quickload :net.bardcode.sequences)
