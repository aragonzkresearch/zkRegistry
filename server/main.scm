(add-to-load-path ".")

(import
 (gnutls) ; required for https
 (json)
 (only (gdbm) GDBM_WRCREAT)
 (scheme base)
 (scheme char)
 (smt)
 (smt db)
 (smt db gdbm)
 (only (smt instance bn254) bn254-number-max)
 (smt instance bn254 poseidon2)
 (smt proof)
 (srfi 13) ; strings
 (srfi 18) ; threads
 (srfi 26) ; cut

 (only (gcrypt pk-crypto) canonical-sexp->sexp sexp->canonical-sexp bytevector->hash-data)
 (web client)
 (web request)
 (web response)
 (web uri)
 (web server)
 (zkreg aux)
 (zkreg eth)
 (zkreg smt))

;; JSON RPC URL
(define rpc-url (or (getenv "RPC_URL") "http://127.0.0.1:8545"))

;; Ethereum smart contract address
(define contract-address (or (getenv "CONTRACT_ADDRESS") "0xb19b36b1456E65E3A6D514D3F715f204BD59f431"))

;; Store data under ~/.zkreg or /tmp/.zkreg if $HOME is not set
(define zkreg-home (string-append (or (getenv "HOME") "/tmp") "/.zkreg"))
(if (not (file-exists? zkreg-home)) (mkdir zkreg-home))

;;;;;;;;;;;;;;;;;;;;
;; Underlying SMT ;;
;;;;;;;;;;;;;;;;;;;;
(define max-depth 160)
(define path (string-append zkreg-home "/db"))
;;(define path "/tmp/zkreg-db")

(define smt-db (make-gdbm-smt-number-db path bn254-number-max GDBM_WRCREAT))
(define smt (make-bn254-poseidon2-smt smt-db max-depth))
(smt-open smt)


;;;;;;;;;;;;;;;;;;;
;; REST endpoint ;;
;;;;;;;;;;;;;;;;;;;

;; Taken from https://www.gnu.org/software/guile/manual/html_node/Web-Examples.html
(define (request-path-components request)
  (split-and-decode-uri-path (uri-path (request-uri request))))
(define (not-found request)
  (values (build-response #:code 404)
          (string-append "Resource not found: "
                         (uri->string (request-uri request)))))
(define (bad-request request)
  (values (build-response #:code 400)
          (string-append "Invalid resource: "
                         (uri->string (request-uri request)))))

(define lis '())

(define handler
  (lambda (request request-body)
    (define path-components (request-path-components request))
    (cond
     ((equal? path-components '("root")) (root-response))
     ((and (= (length path-components) 2)
	   (equal? (car path-components) "proof"))
      (let ((key-number (string->number (cadr path-components) 16)))
	(if key-number (proof-response key-number) (bad-request request))))
     ((and (= (length path-components) 3)
	   (equal? (car path-components) "op-proof"))
      (let ((op-code-number (string->number (cadr path-components) 16))
	    (op-key-number (string->number (caddr path-components) 16)))
	(if (and op-code-number op-key-number) (op-proof-response op-code-number op-key-number)
	    (bad-request request))))
     (else (not-found request)))))

(define (root-response)
  (values '((content-type . (application/json)))
	  (scm->json-string (number->hex-string (or (smt-root smt) (smt-default-value smt))))))
  
(define (proof-response key)
  (values '((content-type . (application/json)))
	  (smt-proof->json-string (smt-get-proof smt key) smt)))

(define (op-proof-response op-code key)
  (values '((content-type . (application/json)))
	  (smt-proof->json-string
	   (guard ; Catch invalid opcode error and return bogus data
	       (_
		(#t (smt-proof #f 0 #f '())))
	     (smt-get-op-proof smt op-code key)) smt)))

(define (zkreg-start)
  (run-server
   handler))

(define smt-thread (make-thread (lambda () (zkreg-start))))


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Ethereum syncing thread ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO: Init code, sync check

(define current-block-number -1)

(define (ethereum-sync block-number)

  ;; Check current block number.
  (define current-block-number (hex-string->number (eth-block-number rpc-url)))
  ;; If it is greater than the current block number, fetch ops and apply them
  (if (> current-block-number block-number)
      (let ((ops (fetch-ops rpc-url contract-address (number->hex-string (+ block-number 1)) (number->hex-string current-block-number))))
	(for-each (lambda (op) (display op) (display "\n") (apply smt-apply-op (cons smt (map hex-string->number op)))) ops)))
  ;; Wait 12 seconds, rinse and repeat
  (sleep 12)
  (ethereum-sync current-block-number))
  
(define sync-thread (make-thread (lambda () (ethereum-sync current-block-number))))

(thread-start! smt-thread)
(thread-start! sync-thread)
