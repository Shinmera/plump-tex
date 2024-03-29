(defpackage #:plump-tex
  (:nicknames #:org.tymoonnext.plump.tex)
  (:use #:cl #:plump)
  (:shadow
   #:parse
   #:serialize)
  (:export
   #:parse
   #:serialize))
(in-package #:plump-tex)
;; This is pretty much a copy of plump/parser.lisp with changes so that it matches common TeX markup.

(defvar *tex-tag-dispatchers* ())
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defvar *whitespace* '(#\Space #\Newline #\Tab #\Return #\Linefeed #\Page)))

(define-matcher tex-tag-start (and (is #\\)
                                   (not (prev (is #\\)))
                                   (next (or (in #\a #\z)
                                             (in #\A #\Z)
                                             (is #\@)))))

(define-matcher tex-block-start (and (is #\{)
                                     (not (prev (is #\\)))))

(define-matcher tex-block-end (and (is #\})
                                   (not (prev (is #\\)))))

(define-matcher tex-tag-name (or (in #\a #\z) (in #\A #\Z) (in #\0 #\9) (is #\@)))

(define-matcher tex-attribute-closing (or (find *whitespace*)
                                          (any #\, #\])))


(defun replace-escaped (string)
  (cl-ppcre:regex-replace-all "\\\\([&%$#_{}~^\\\\])" string "\\1"))

(defun read-tex-name ()
  (consume-until (make-matcher (not :tex-tag-name))))

(defun read-tex-text ()
  (make-text-node
   *root*
   (replace-escaped
    (consume-until (make-matcher (or :tex-block-start
                                     :tex-block-end
                                     :tex-tag-start))))))

(defun read-tex-attribute-name ()
  (replace-escaped
   (consume-until (make-matcher (or (and (is #\=)
                                         (not (prev (is #\\))))
                                    :tex-attribute-closing)))))

(defun read-tex-children ()
  (loop for peek = (peek)
        while peek
        until (char= peek #\})
        do (or (read-tex-tag)
               (read-tex-block)
               (read-tex-text))
        finally (consume)))

(defun read-tex-attribute-value ()
  (case (peek)
    (#\" (prog1 (replace-escaped
                 (consume-until (make-matcher (and (is #\") (not (prev (is #\\)))))))
           (consume)))
    (T (replace-escaped
        (consume-until (make-matcher :tex-attribute-closing))))))

(defun read-tex-attribute ()
  (let ((name (read-tex-attribute-name))
        (next (consume))
        (value ""))
    (case next
      ((nil))
      (#\=
       (setf value (read-tex-attribute-value)))
      (T
       (unread)))
    (cons name value)))

(defun read-tex-attributes ()
  (loop with table = (make-attribute-map)
        for char = (peek)
        do (case char
             ((nil)
              (return table))
             (#\]
              (advance)
              (return table))
             (#.*whitespace*
              (advance))
             (#\,
              (advance))
             (T
              (let ((entry (read-tex-attribute)))
                (setf (gethash (car entry) table) (cdr entry)))))))

(defun read-tex-standard-tag (name)
  (let* ((closing (peek))
         (attrs (if (and closing (char= closing #\[))
                    (prog2 (advance) (read-tex-attributes)
                      (setf closing (peek)))
                    (make-attribute-map))))
    (case closing
      (#\{
       (advance)
       (let ((*root* (make-element *root* name :attributes attrs)))
         (read-tex-children)
         *root*))
      (T (make-element *root* name :attributes attrs)))))

(defun read-tex-tag ()
  (when (funcall (make-matcher :tex-tag-start))
    (consume) ; Consume backslash
    (let ((name (read-tex-name)))
      (or (loop for (d test func) in *tex-tag-dispatchers*
                when (funcall (the function test) name)
                do (return (funcall (the function func) name))
                finally (return (read-tex-standard-tag name)))
          (progn
            (unread-n (length name))
            (let ((text (read-tex-text)))
              (setf (text text) (concatenate 'string "\\" (text text)))
              text))))))

(defun read-tex-block ()
  (when (funcall (make-matcher :tex-block-start))
    (read-tex-standard-tag "div")))

(defun read-tex-root (&optional (root (make-root)))
  (let ((*root* root))
    (loop while (peek)
          do (or (read-tex-tag)
                 (read-tex-block)
                 (read-tex-text)))
    *root*))

(defgeneric parse (input &key root)
  (:method ((input string) &key root)
    (let ((input (typecase input
                   (simple-string input)
                   (string (copy-seq input)))))
      (with-lexer-environment (input)
        (if root
            (read-tex-root root)
            (read-tex-root)))))
  (:method ((input pathname) &key root)
    (with-open-file (stream input :direction :input)
      (parse stream :root root)))
  (:method ((input stream) &key root)
    (parse (plump::slurp-stream input) :root root)))

(defgeneric serialize (node &optional stream)
  (:documentation "Serialize the given node in TeX syntax and print it to the stream.")
  (:method ((node text-node) &optional (stream *standard-output*))
    (format stream "~a" (text node)))
  (:method ((node element) &optional (stream *standard-output*))
    (unless (equal (tag-name node) "div")
      (format stream "\\~a" (tag-name node)))
    (serialize (attributes node) stream)
    (when (> (length (children node)) 0)
      (format stream "{")
      (loop for child across (children node)
            do (serialize child stream))
      (format stream "}")))
  (:method ((table hash-table) &optional (stream *standard-output*))
    (when (> (hash-table-count table) 0)
      (format stream "[")
      (let ((list (loop for key being the hash-keys of table
                        for val being the hash-values of table
                        collecting (format nil "~a~@[=~s~]" key val))))
        (format stream "~{~a~#[~:;, ~]~}" list))
      (format stream "]")))
  (:method ((node nesting-node) &optional (stream *standard-output*))
    (loop for child across (children node)
          do (serialize child stream)))
  (:method ((nodes vector) &optional (stream *standard-output*))
    (loop for child across nodes
          do (serialize child stream))))
