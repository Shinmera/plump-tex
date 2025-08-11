(defsystem plump-tex-test
  :name "Plump-TeX-Test"
  :version "0.1.0"
  :license "zlib"
  :author "Yukari Hafner <shinmera@tymoon.eu>"
  :maintainer "Yukari Hafner <shinmera@tymoon.eu>"
  :description "Testing system for Plump-TeX"
  :homepage "https://shinmera.com/docs/plump-tex/"
  :bug-tracker "https://shinmera.com/project/plump-tex/issues"
  :source-control (:git "https://shinmera.com/project/plump-tex.git")
  :serial T
  :components ((:file "plump-tex-test"))
  :depends-on (:plump-tex :fiveam))
