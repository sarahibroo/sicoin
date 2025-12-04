;; sicoin.clar
;; A simple SIP-010–style fungible token implementation for the SICOIN token.

(impl-trait 'SP3FBR2AGK1C6QKPJ6K7GZ1GZHB7G9N76H0D2G1G.sip010-ft-standard.sip010-ft-trait)

(define-fungible-token sicoin)

;; -----------------------------------------------------------------------------
;; Constants & errors
;; -----------------------------------------------------------------------------

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))
(define-constant ERR-MINT-FAILED (err u102))

(define-constant TOKEN-NAME "Sicoin")
(define-constant TOKEN-SYMBOL "SIC")
(define-constant TOKEN-DECIMALS u6)

;; -----------------------------------------------------------------------------
;; Data
;; -----------------------------------------------------------------------------

(define-data-var token-admin principal contract-owner)
(define-data-var total-supply uint u0)

;; -----------------------------------------------------------------------------
;; Read-only functions (SIP-010 metadata)
;; -----------------------------------------------------------------------------

(define-read-only (get-name)
  (ok TOKEN-NAME))

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance sicoin who)))

(define-read-only (get-token-uri)
  (ok none))

;; -----------------------------------------------------------------------------
;; Administrative helpers
;; -----------------------------------------------------------------------------

(define-read-only (get-admin)
  (ok (var-get token-admin)))

(define-public (set-admin (new-admin principal))
  (if (is-eq tx-sender (var-get token-admin))
      (begin
        (var-set token-admin new-admin)
        (ok true))
      ERR-NOT-AUTHORIZED))

;; -----------------------------------------------------------------------------
;; Public token functions
;; -----------------------------------------------------------------------------

;; Mint new tokens to a recipient. Only the admin may mint.
(define-public (mint (amount uint) (recipient principal))
  (if (is-eq tx-sender (var-get token-admin))
      (let ((mint-result (ft-mint? sicoin amount recipient)))
        (match mint-result
          result
            (begin
              (var-set total-supply (+ (var-get total-supply) amount))
              (ok true))
          error-code
            ERR-MINT-FAILED))
      ERR-NOT-AUTHORIZED))

;; Transfer tokens between principals, following SIP-010 style.
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (if (is-eq tx-sender sender)
      (if (>= (ft-get-balance sicoin sender) amount)
          (ft-transfer? sicoin amount sender recipient)
          ERR-INSUFFICIENT-BALANCE)
      ERR-NOT-AUTHORIZED))

;; Convenience wrapper using tx-sender as the sender.
(define-public (transfer-from-tx-sender (amount uint) (recipient principal))
  (transfer amount tx-sender recipient)
