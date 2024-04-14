(define-library (zkreg smt)
 (export number->hex-string smt-proof->json-string smt-apply-op smt-get-op-proof)
 (import
  (json)
  (scheme base)
  (smt)
  (smt proof)
  (srfi 1)
  (zkreg aux)
  )
 (begin
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; SMT helper procedures ;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;

   (define (smt-proof->json-string proof smt)
     (define max-depth (smt-max-depth smt))
     (define proof-value (smt-proof-value proof))
     (scm->json-string
      (list
       (cons 'inclusion (smt-inclusion-proof? proof))
       (cons 'empty_leaf (not proof-value))
       (cons 'key (number->hex-string (smt-proof-key proof)))
       (cons 'value (number->hex-string (or proof-value 0)))
       (cons 'siblings (vector-map number->hex-string (let ((v (make-vector max-depth (smt-default-value smt)))
			     (sib-iter (zip (iota max-depth 0) (smt-proof-siblings proof))))
			 (for-each (lambda (p) (vector-set! v (car p) (cadr p) )) sib-iter)
			 v))))))
   
   ;; SMT op code proof
   (define (smt-get-op-proof smt op-code op-key)
     (case op-code
       ((0 1) (smt-get-proof smt op-key))
       ((2) (smt-get-adjacent-proof smt op-key))
       (else => (error "Invalid opcode" op-code))))

   ;; SMT op application
   (define (smt-apply-op smt op-code op-key op-value)
     (case op-code
       ((0) (smt-insert! smt op-key op-value))
       ((1) (smt-update! smt op-key op-value))
       ((2) (smt-delete! smt op-key))
       (else => (error "Invalid opcode" op-code))))))
