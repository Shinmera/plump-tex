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
  (is (equal (parse-print "test") "test"))
  (is (equal (parse-print " \\test") " <test/>"))
  (is (equal (parse-print " {}") " <div/>"))
  (is (equal (parse-print " {1}") " <div>1</div>"))
  (is (equal (parse-print " {{}}") " <div><div/></div>"))
  (is (equal (parse-print " \\test{1 2 3}") " <test>1 2 3</test>"))
  (is (equal (parse-print " \\a{\\b{\\c{}}}") " <a><b><c/></b></a>"))
  (is (equal (parse-print " \\a{\\b{\\c1{123}\\c2{123}}}")
             " <a><b><c1>123</c1><c2>123</c2></b></a>")))

(run! 'tests)
