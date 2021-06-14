;;;; package.lisp

(defpackage #:net.bardcode.sequences
  (:use #:cl)
  (:nicknames :seq)
  (:export #:cat #:empty? #:filter #:interleave #:interpose #:join))
