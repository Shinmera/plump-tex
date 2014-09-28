(defpackage :plump-tex-test
  (:use :cl :fiveam))
(in-package :plump-tex-test)

(def-suite tests)
(in-suite tests)

(defun serialize-to-string (node)
  (with-output-to-string (stream)
    (plump:serialize node stream)))

(defun parse-print (string)
  (serialize-to-string (plump-tex:parse string)))

(test general
  (is (equal (parse-print "test") "test")))

(run! 'tests)
