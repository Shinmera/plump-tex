#|
 This file is a part of Plump
 (c) 2014 TymoonNET/NexT http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage org.tymoonnext.plump.tex.test.asdf
  (:use :cl :asdf))
(in-package :org.tymoonnext.plump.tex.test.asdf)

(defsystem plump-tex-test
  :name "Plump-Tex-Test"
  :version "0.1.0"
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "Testing system for Plump-TeX"
  :homepage "https://github.com/Shinmera/plump"
  :serial T
  :components ((:file "plump-tex-test"))
  :depends-on (:plump :fiveam))
