#|
 This file is a part of Plump
 (c) 2014 TymoonNET/NexT http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage org.tymoonnext.plump.tex.test.asdf
  (:use :cl :asdf))
(in-package :org.tymoonnext.plump.tex.test.asdf)

(defsystem plump-tex-test
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :components ((:module "t"
                :components
                ((:file "plump-tex"))))
  :depends-on (:plump-tex :fiveam))
