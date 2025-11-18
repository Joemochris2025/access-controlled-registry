;; ------------------------------------------------------------
;; access-controlled-registry.clar
;; A basic access-controlled registry where only the admin
;; can add or remove records.
;; ------------------------------------------------------------

;; ---------------------------
;; 1. Constants & Admin
;; ---------------------------

;; The contract deployer becomes the admin.
(define-constant CONTRACT-ADMIN tx-sender)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))

;; ---------------------------
;; 2. Data Storage
;; ---------------------------

;; Registry map storing key-value pairs
;; replaced em-dash with regular hyphen
(define-map registry
  { key: uint }
  { value: (string-ascii 50) })

;; ---------------------------
;; 3. Read-Only Functions
;; ---------------------------

;; Fetch a record by its key
(define-read-only (get-record (k uint))
  (ok (map-get? registry { key: k }))
)

;; Check if caller is admin
(define-read-only (is-admin (caller principal))
  (ok (is-eq caller CONTRACT-ADMIN))
)

;; ---------------------------
;; 4. Public Functions
;; ---------------------------

;; Add a new record - admin only
;; replaced em-dash with regular hyphen
(define-public (add-record (k uint) (v (string-ascii 50)))
  (if (is-eq tx-sender CONTRACT-ADMIN)
      (begin
        (map-set registry { key: k } { value: v })
        (ok true)
      )
      ERR-NOT-AUTHORIZED)
)

;; Remove a record - admin only
;; replaced em-dash with regular hyphen and fixed match syntax
(define-public (remove-record (k uint))
  (if (is-eq tx-sender CONTRACT-ADMIN)
      (match (map-get? registry { key: k })
        existing (begin
          (map-delete registry { key: k })
          (ok true)
        )
        ERR-NOT-FOUND
      )
      ERR-NOT-AUTHORIZED)
)
