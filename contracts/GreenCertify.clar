;; GreenCertify - Renewable energy certificate verification system
(define-map energy-certificates uint {
  producer: principal,
  energy-source: (string-utf8 64),
  generation-details: (string-utf8 256),
  production-period: uint,
  facility-address: (string-utf8 64),
  verified: bool
})

(define-map producer-certificates principal (list 100 uint))
(define-map energy-auditors principal bool)
(define-data-var certificate-id-nonce uint u0)

;; Error codes
(define-constant err-not-producer (err u500))
(define-constant err-not-auditor (err u501))
(define-constant err-certificate-not-found (err u502))
(define-constant err-access-restricted (err u403))
(define-constant err-certificate-limit-exceeded (err u504))
(define-constant err-invalid-auditor-address (err u505))
(define-constant err-invalid-energy-source (err u506))
(define-constant err-invalid-generation-details (err u507))
(define-constant err-invalid-production-period (err u508))
(define-constant err-invalid-facility-address (err u509))
(define-constant err-invalid-certificate-id (err u510))

;; Contract regulator for energy certification
(define-constant contract-regulator tx-sender)

;; Add energy auditor
(define-public (add-energy-auditor (auditor principal))
  (begin
    ;; Check if sender is contract regulator
    (asserts! (is-eq tx-sender contract-regulator) err-access-restricted)
    
    ;; Validate auditor principal
    (asserts! (not (is-eq auditor 'SP000000000000000000002Q6VF78)) err-invalid-auditor-address)
    
    ;; Add auditor to registry
    (ok (map-set energy-auditors auditor true))
  )
)

;; Register energy certificate
(define-public (register-energy-certificate 
  (energy-source (string-utf8 64)) 
  (generation-details (string-utf8 256)) 
  (production-period uint) 
  (facility-address (string-utf8 64)))
  (let
    ((certificate-id (var-get certificate-id-nonce))
     (producer tx-sender)
     (current-certificates (default-to (list) (map-get? producer-certificates producer))))
    
    ;; Validate inputs
    (asserts! (> (len energy-source) u0) err-invalid-energy-source)
    (asserts! (> (len generation-details) u0) err-invalid-generation-details)
    (asserts! (> production-period u0) err-invalid-production-period)
    (asserts! (> (len facility-address) u0) err-invalid-facility-address)
    
    ;; Check certificate registration limit
    (asserts! (< (len current-certificates) u100) err-certificate-limit-exceeded)
    
    ;; Store energy certificate information
    (map-set energy-certificates certificate-id {
      producer: producer,
      energy-source: energy-source,
      generation-details: generation-details,
      production-period: production-period,
      facility-address: facility-address,
      verified: false
    })
    
    ;; Update producer's certificate list
    (let 
      ((updated-certificate-list (unwrap-panic (as-max-len? (concat (list certificate-id) current-certificates) u100))))
      (map-set producer-certificates producer updated-certificate-list)
    )
    
    ;; Increment certificate ID nonce
    (var-set certificate-id-nonce (+ certificate-id u1))
    
    (ok certificate-id)))

;; Verify energy certificate
(define-public (verify-energy-certificate (certificate-id uint))
  (begin
    ;; Validate certificate ID
    (asserts! (< certificate-id (var-get certificate-id-nonce)) err-invalid-certificate-id)
    
    (let
      ((certificate (unwrap! (map-get? energy-certificates certificate-id) err-certificate-not-found)))
      
      ;; Check if sender is energy auditor
      (asserts! (default-to false (map-get? energy-auditors tx-sender)) err-not-auditor)
      
      ;; Update certificate verification status
      (ok (map-set energy-certificates certificate-id (merge certificate {verified: true})))
    )
  )
)

;; Get energy certificate details
(define-read-only (get-energy-certificate (certificate-id uint))
  (map-get? energy-certificates certificate-id))

;; Get producer's certificates
(define-read-only (get-producer-certificates (producer principal))
  (default-to (list) (map-get? producer-certificates producer)))

;; Check energy auditor status
(define-read-only (is-energy-auditor (address principal))
  (default-to false (map-get? energy-auditors address)))