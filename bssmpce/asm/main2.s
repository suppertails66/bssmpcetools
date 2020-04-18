
.include "sys/sms_arch.s"
  ;.include "base/ram.s"
.include "base/macros.s"
  ;.include "res/defines.s"

.rombankmap
  bankstotal 32
  banksize $4000
  banks 32
.endro

.emptyfill $FF

.background "mkr.gg"

;===============================================
; Update region code in header
;===============================================
.bank 1 slot 0
.org $3FFF
.section "regcode" overwrite
  .db $7C   ; 7 = GG international
            ; C = 32kb rom size for checksum (WLA computed a 32kb
            ; checksum and set this when the .smstag directive
            ; was issued -- we're preserving that value)
.ends

