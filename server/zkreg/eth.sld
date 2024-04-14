(define-library (zkreg eth)
  (export
   eth-block-number
   fetch-ops
   json-rpc-call)
  (import
   (rename (prefix (only (gcrypt pk-crypto) sign verify) gcrypt#)) ; secp256k1-related procedures
   (only (gcrypt pk-crypto) canonical-sexp->sexp sexp->canonical-sexp bytevector->hash-data) ; sim.
   (json)
   (scheme base)
   (scheme cxr)
   (srfi 27) ; rng
   (web client)
   )
  (begin
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Ethereum-relevant helpers ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; Procedures for JSON RPC calls
    ;; `method` is a symbol and `parameters` is a vector.
    (define (json-rpc-call rpc-url method parameter-vector)
      (define id (random-integer 100))
      (define request-body (scm->json-string
			    (append
			     `((jsonrpc . "2.0")
			       (id . ,id)
			       (method . ,method))
			     (if parameter-vector
				 `((params . ,parameter-vector))
				 '()))))
      ;;  (display (string-append request-body "\n"))
      (define-values (response response-body) (http-request rpc-url
							    #:method 'POST
							    #:body
							    (string->utf8
							     request-body)
							    #:headers '((Content-Type . "application/json"))))
      ;;  (display (string-append (utf8->string response-body) "\n"))
      (define result-pair (assoc "result" (json-string->scm (utf8->string response-body))))
      (and result-pair (cdr result-pair)))

    (define (eth-block-number rpc-url)
      (json-rpc-call rpc-url 'eth_blockNumber #f))

    ;; Procedure for fetching SMT ops from the blockchain
    ;; Returns a list of lists of the form (op-code op-key op-value).
    (define (fetch-ops rpc-url contract-address from-block to-block)
      (define call-response (json-rpc-call rpc-url 'eth_getLogs
					   (vector
					    `((fromBlock . ,from-block)
					      (toBlock . ,to-block)
	       				      (address . ,contract-address)
					      (topics . ,(vector "0x8f6e25d93f009e6dd8a95c941dbfbe26f08e8da8b24820103bf5ad121f32b113")) #|keccak256 hash of event signature|# ))))
      ;; Map the response vector appropriately
      (vector->list
       (vector-map
	(lambda (event) (cdr (vector->list event)))
	(vector-map (lambda (pairlis) (let ((topics (assoc "topics" pairlis)))
				   (if topics (cdr topics)
				       #f))) call-response))))

    (define (make-op-filter rpc-url contract-address)
      (json-rpc-call rpc-url 'eth_newFilter
		     (vector
		      `((address . ,contract-address)
			(topics . ,(vector "0x8f6e25d93f009e6dd8a95c941dbfbe26f08e8da8b24820103bf5ad121f32b113"))))))

    (define (eth-get-filter-changes rpc-url id)
      (json-rpc-call rpc-url 'eth_getFilterChanges
		     (vector id)))))

