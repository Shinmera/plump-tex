#|
 This file is a part of Plump
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:plump-tex-test
  (:nicknames #:org.tymoonnext.plump.tex.test)
  (:use #:cl #:fiveam))
(in-package :plump-tex-test)

(def-suite tests)
(in-suite tests)

(defun parse-equal (parse &rest possibilities)
  (let ((result (with-output-to-string (stream)
                  (plump:serialize (plump-tex:parse parse) stream))))
    (loop for possibility in possibilities
          thereis (string= result possibility))))

(test text
  (is (parse-equal "foo"
                   "foo"))

  (is (parse-equal "\\\\"
                   "\\"))

  (is (parse-equal "\\}\\{\\&\\%\\$\\#\\_\\~\\^\\"
                   "}{&amp;%$#_~^\\")))

(test tag
  (is (parse-equal "\\foo"
                   "<foo/>"))
  
  (is (parse-equal "\\foo[bar]"
                   "<foo bar=\"\"/>"))
  
  (is (parse-equal "\\foo[bar=baz]"
                   "<foo bar=\"baz\"/>"))

  (is (parse-equal "\\foo[bar,baz]"
                   "<foo bar=\"\" baz=\"\"/>"
                   "<foo baz=\"\" bar=\"\"/>")))

(test block
  (is (parse-equal "{}"
                   "<div/>"))
  
  (is (parse-equal "{1}"
                   "<div>1</div>"))
  
  (is (parse-equal "{{}}"
                   "<div><div/></div>")))


(test tagblock
  (is (parse-equal "\\foo{bar baz}"
                   "<foo>bar baz</foo>"))

  (is (parse-equal "\\foo{\\bar{baz}}"
                   "<foo><bar>baz</bar></foo>"))

  (is (parse-equal "\\foo{bar}\\baz{}"
                   "<foo>bar</foo><baz/>")))

(test sanity
  (is (parse-equal "\\foo{bar"
                   "<foo>bar</foo>"))

  (is (parse-equal "{{}"
                   "<div><div/></div>"))

  (is (parse-equal "\\foo[bar"
                   "<foo bar=\"\"/>"))

  (is (parse-equal "\\foo[bar="
                   "<foo bar=\"\"/>")))

(defmethod asdf:perform ((op asdf:test-op) (system (eql (asdf:find-system :plump-tex-test))))
  (run! 'tests))
