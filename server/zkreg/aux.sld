(define-library (zkreg aux)
  (export
   hex-string->bytevector
   hex-string->number
   number->bytevector
   number->hex-string
   number->toml
   number-list->toml)
  (import
   (scheme base)
   (scheme case-lambda)
   (scheme inexact) ; log
   (srfi 13) #| strings |# )
  (begin
    ;; Useful conversion procedures for numbers/hex strings/bytevectors.
    (define hex-string->number
  (lambda (str)
    (and
     (> (string-length str) 2)
     (equal? (string-take str 2) "0x")
     (string->number (string-drop str 2) 16))))

(define number->hex-string
  (case-lambda
    ((n)
     (let* ((number-string (number->string n 16))
	    (padding (if (even? (string-length number-string))
			    "" "0")))
       (string-append "0x" padding number-string )))
    ((n number-of-bytes)  
     (let* ((number-string (number->string n 16))
	    (byte-excess (- (* 2 number-of-bytes) (string-length number-string))))
       (and
	(>= byte-excess 0)
	(string-append "0x" (make-string byte-excess #\0)
		       number-string))))))

(define number->bytevector
  (case-lambda
    ((n) (number->bytevector n (exact (ceiling (log n 256)))))
    ((n bv-size)
     (define bv (make-bytevector bv-size 0))
     (let loop ((n n)
		(i (- bv-size 1)))
       (if (or (zero? n) (< i 0)) bv
	   (let-values (((new-n byte) (truncate/ n 256)))
	     (bytevector-u8-set! bv i byte)
	     (loop new-n (- i 1))))))))

(define hex-string->bytevector
  (lambda (str . rest) (apply number->bytevector (cons (hex-string->number str) rest))))

(define (number->toml n)
  (string-append "\"" (number->hex-string n) "\""))

(define (number-list->toml lis)
  (define str (string-append "["
			     (apply string-append (map (lambda (n) (string-append (number->toml n) ",")) lis))))
  (string-set! str (- (string-length str) 1) #\])
  str)))
