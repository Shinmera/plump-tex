(defsystem plump-tex
  :name "Plump-TeX"
  :version "0.1.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Rudimentary parser turning TeX-like syntax into a Plump DOM."
  :homepage "https://Shinmera.github.io/plump-tex/"
  :bug-tracker "https://github.com/Shinmera/plump-tex/issues"
  :source-control (:git "https://github.com/Shinmera/plump-tex.git")
  :serial T
  :components ((:file "plump-tex"))
  :depends-on (:plump
               :cl-ppcre)
  :in-order-to ((test-op (test-op :plump-tex-test))))
