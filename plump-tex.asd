(defsystem plump-tex
  :name "Plump-TeX"
  :version "0.1.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Rudimentary parser turning TeX-like syntax into a Plump DOM."
  :homepage "https://shinmera.com/docs/plump-tex/"
  :bug-tracker "https://shinmera.com/project/plump-tex/issues"
  :source-control (:git "https://shinmera.com/project/plump-tex.git")
  :serial T
  :components ((:file "plump-tex"))
  :depends-on (:plump
               :cl-ppcre)
  :in-order-to ((test-op (test-op :plump-tex-test))))
