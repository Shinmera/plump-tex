#|
 This file is a part of Plump
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defsystem plump-tex
  :name "Plump-TeX"
  :version "0.1.0"
  :license "Artistic"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :description "Rudimentary parser turning TeX-like syntax into a Plump DOM."
  :homepage "https://github.com/Shinmera/plump-tex"
  :serial T
  :components ((:file "plump-tex"))
  :depends-on (:plump
               :cl-ppcre)
  :in-order-to ((test-op (test-op :plump-tex-test))))
