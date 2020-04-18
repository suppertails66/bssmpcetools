
;.include "sys/pce_arch.s"
;.include "base/macros.s"

.memorymap
   defaultslot     0
   ; ROM area
   slotsize        $6800
   slot            0       $3000
.endme

.rombankmap
  bankstotal 1
  banksize $6800
  banks 1
.endro

.emptyfill $FF

.background "bssm_boot_1000.bin"


.define lineHeightSetting $32C8
.define charSpaceSetting $32C9
.define fontSectorNum $20
.define fontSectorLen $1
.define fontSectorDstAddr $D800
.define fontWidthTableAddr $DF80

.define _A $F8
.define _AL $F8
.define _AH $F9
.define _B $FA
.define _BL $FA
.define _BH $FB
.define _C $FC
.define _CL $FC
.define _CH $FD
.define _D $FE
.define _DL $FE
.define _DH $FF

.define op19Subop_transferAltToSatb $20
.define op19Subop_clearSatb $21
.define op19Subop_loadEdSub $22
.define op19Subop_fillBgPalettes $23
.define op19Subop_stopSubThread $24
.define altSatbTransferSrc $0F00

.define currentEdSubPos $3268+(3*2)
.define edSubPatternCount $3268+(4*2)

;===============================================
; Adjust title screen cursor position 8 pixels
; left so longer English strings are centered
;===============================================

;.bank 3 slot 1
;.org $01DF
;.section "titlecursor" overwrite
;  ld d,$58  ; x-position (orig: 60)
;.ends

.bank 0 slot 0

.org $0F90
.section "bootjump" overwrite
  ; jump to extra code before running START.MES
  jmp extraBootCode
.ends

;===============================================
; Jump to new font width update routine
;===============================================

.org $10BC
.section "fontwidthjump" overwrite
  ; replace call to kanji load
  jsr fontWidthUpdate
.ends

;===============================================
; 1-byte text encoding
;===============================================

.org $195D
.section "1bytetext" overwrite
  do_1bytetext:
  stz _AH       ; high byte = 0
  txa           ; get raw low byte (+#$80)
  sec
  sbc #$80      ; subtract #$80
  sta _AL       ; write actual low byte
  jmp $49EF     ; jump past obsolete code
.ends

.org $19AC
.section "1bytetext2" overwrite
  jmp do_1bytetext
.ends

;===============================================
; Line height = 12px
;===============================================

.define textLineHeight 12

.org $02C8
.section "line height" overwrite
  .db textLineHeight
.ends

;===============================================
; Use 7F as linebreak character
;===============================================

.org $19EF
.section "fflinebreak" overwrite
  .define normalPrint $4A07
  .define linebreakPrint $4A01

  lda $F8       ; fetch low byte of encoding
  cmp #$7F      ; if 7F, branch to newline code
  bne +
  jmp linebreakPrint
  +:
  jmp normalPrint     ; if anything else, branch to
                      ; normal print code
.ends

;===============================================
; fix digit printing
;===============================================

; force ascii printing
.org $2325
.section "force ascii digit print" overwrite
  nop
  nop
.ends

; no "06" op tags for "ascii" text
.org $2386
.section "digit print no 06 tags" overwrite
  lda #$00
.ends

; change offset from raw digit to corresponding character code

.define digitToCharConversionOffset $01+$80

.org $236A
.section "digit to char conversion" overwrite
  adc #digitToCharConversionOffset
.ends

;===============================================
; no auto-newline
;===============================================

.org $1A23
.section "no auto-newline" overwrite
  rts
.ends

;===============================================
; new op19 subop extension.
; this enables the sprite attribute table
; to be transferred to SATB from VRAM $0F00
; instead of $1000, because $1000+ are used to
; store patterns for full-screen events where
; we need sprite subtitles.
;===============================================

.org $037A
.section "op19 subop extension" overwrite
  jmp op19SubopExtension
.ends

;===============================================
; extend load size of file index
;===============================================

.org $0F77
.section "size of file index" overwrite
  ; $A000 bytes
  lda #$12+2
.ends

;===============================================
; routine to fetch a byte from backmem
;===============================================

.org $0048
.section "fetch backmem byte" overwrite
  ; A == src
  fetchBackmemByte:
    ; load alt MPRs
    jsr $3619
    
      ; get byte
      lda (_A)
    
    pha
      ; restore MPRs
      jsr $3642
    pla
    rts
.ends

;===============================================
; move card error code from 52000 to 40000
; so we have room to expand it
;===============================================

.define newCardErrorCodeRecordNum $80
.define newCardErrorCodeRecordLen $16

; position
.org $40EC
.section "card error 1" overwrite
  lda #newCardErrorCodeRecordNum
.ends

; length
.org $40F0
.section "card error 2" overwrite
  lda #newCardErrorCodeRecordLen
.ends

;===============================================
; disable use of secondary base address.
; the original game makes use of a bios feature
; that allows a secondary, redundant copy of the
; disc data to be used in case of disc damage.
; this is not terribly useful in the context
; of a translation patch (emulators should never
; have "disc damage", and anyone playing on a
; real console can just burn another disc),
; so we just disable the feature and remove the
; redundant data, saving some space.
;===============================================

.org $4041
.section "no secondary cd base address" overwrite
  nop
  nop
  nop
.ends













;============================================================================
; New code
;============================================================================

.org $4109
.section "bootadd" SIZE $F7 overwrite
  extraBootCode:
  ;  lda #$0A
  ;  sta charSpaceSetting
    
    ;===============================================
    ; Load the new font to RAM
    ;===============================================
    
    ; set target address
    stz _CL
    lda #>fontSectorNum
    sta _CH
    lda #<fontSectorNum
    sta _DL
    
    ; read type: local
    lda #$01
    sta _DH
    
    ; destination
    lda #<fontSectorDstAddr
    sta _BL
    lda #>fontSectorDstAddr
    sta _BH
    
    ; length
    lda #fontSectorLen
    sta _AL
    
    ; call BIOS read routine
    jsr $E009
    
    ;===============================================
    ; Return to normal flow
    ;===============================================
    
    ; run START.MES
    jmp $46C3
  
  ;===============================================
  ; Intercept BIOS character load calls and
  ; redirect them to our custom font.
  ; Also update character spacing to match
  ; character to be printed.
  ;
  ; A = character code
  ; B = destination for 1bpp data
  ;===============================================
  fontWidthUpdate:

    ;===============================================
    ; DEBUG: force text skipping on
    ;===============================================
    
/*    lda $32B6
    ora #$02
    sta $32B6 */
  
    ;===============================================
    ; update width
    ;===============================================
    
    ; look up width table entry for character code
    clc
    lda _AL
    adc #<fontWidthTableAddr
    sta _CL
;    cla
    lda _AH
    adc #>fontWidthTableAddr
    sta _CH
    
    ; set width
    lda (_C)
    sta charSpaceSetting
  
    ;===============================================
    ; mutiply character code by 24
    ;===============================================
    
    ; multiply by 8
    asl _AL
    rol _AH
    asl _AL
    rol _AH
    asl _AL
    rol _AH
    
    ; copy result to C
    lda _AL
    sta _CL
    lda _AH
    sta _CH
    
    ; multiply again to get *16
    asl _AL
    rol _AH
    
    ; add *8 to get *24
    clc
    lda _AL
    adc _CL
    sta _AL
    lda _AH
    adc _CH
    sta _AH
  
    ;===============================================
    ; add to base address
    ;===============================================
    
    clc
    lda #<fontSectorDstAddr
    adc _AL
    sta _AL
    lda #>fontSectorDstAddr
    adc _AH
    sta _AH
  
    ;===============================================
    ; copy data
    ;===============================================
    ldy #$18
    -:
      lda (_A),y
      sta (_B),y
      dey
      bne -
    ; copy first byte
    lda (_A)
    sta (_B)
    
    rts
  
  op19SubopExtension:
    ; new SATB transfer
    cmp #op19Subop_transferAltToSatb
    bne +
      ; src = VRAM $0F00
      lda #<altSatbTransferSrc
      sta $2214
      lda #>altSatbTransferSrc
      jmp $3FBE
    +:
    cmp #op19Subop_loadEdSub
    bne +
      ; $F8 = src
      lda currentEdSubPos
      sta _AL
      lda currentEdSubPos+1
      sta _AH
      
      
      jsr fetchBackmemByte
      
      ; write to dst as word
      sta edSubPatternCount
      stz edSubPatternCount+1
      
      ; done
      jmp $4729
      
      ; src = $F8
;      lda _AL
;      sta <currentEdSubPos
;      lda _AH
;      sta >currentEdSubPos
    +:
    cmp #op19Subop_fillBgPalettes
    bne +
      ; modify the instruction at $58A8 to target only the bg palettes
      ; old: cmp #$04
      ; new: cmp #$02
      lda #$02
      sta $58A8+1
      
      ; do the normal fill routine
      jsr $5873
      
      ; restore changed instruction
      lda #$04
      sta $58A8+1
      
      ; destroy argument 1's type value so the fade routine won't
      ; use it.
      ; this value must not be 1 (indicating an int argument).
;      stz $2634
      
      jmp $4729
    +:
    cmp #op19Subop_stopSubThread
    bne +
      jsr $5EE0
      jmp $4729
    +:
    cmp #op19Subop_clearSatb
    bne +
      ; call bios routine to clear SAT
      lda #<altSatbTransferSrc
      sta $2214
      lda #>altSatbTransferSrc
      sta $2215
      jsr $E0A2
      ;!!!!! drop through
    ; give up
    +:
    jmp $4729
  
.ends


