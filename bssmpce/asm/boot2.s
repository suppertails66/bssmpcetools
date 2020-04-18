
;.include "sys/pce_arch.s"
;.include "base/macros.s"

.memorymap
   defaultslot     0
   ; ROM area
   slotsize        $B000
   slot            0       $3000
.endme

.rombankmap
  bankstotal 1
  banksize $B000
  banks 1
.endro

.emptyfill $FF

.background "bssm_carderror_52000.bin"


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

;============================================================================
; existing routines
;============================================================================

.define transferToVram $4AC8
.define waitForVsync $E07B

;===============================================
; do not turn on bg/sprites before needed
;===============================================

.org $1257
.section "bg/sprites off" overwrite
  nop
  nop
  nop
.ends

;===============================================
; run new init code
;===============================================

.org $1285
.section "new init" overwrite
  jsr newScreenInit
  
  ; bg/sprites on
  jsr $E096
  
  ; skip drawing old error message
  jmp $430A
.ends

;===============================================
; new palette
;===============================================

.org $1048
.section "new palette" overwrite
  .incbin "out/pal/carderror.pal"
.ends

;===============================================
; ???
; i have no idea what this call was for,
; but it totally wrecks the palette and
; we don't need it.
;===============================================

.org $137D
.section "?" overwrite
  nop
  nop
  nop
.ends

;===============================================
; run new subtitle
;===============================================

.org $13B1
.section "new subs" overwrite
  jmp doSubtitles
.ends












;============================================================================
; New code
;============================================================================

.unbackground $3000 $AFFF

.define tileDataLoadAddr $1000
.define bgMapLoadAddr $0000
.define messageMapLoadAddr $02E0

.org $3000
.section "boot2add" free
  tileData: .incbin "out/grp/carderror.bin" FSIZE tileDataSize
  messageBgMap: .incbin "out/maps/carderror_bg.bin" FSIZE messageBgMapSize
  messageMap00Map: .incbin "out/maps/carderror_map00.bin" FSIZE messageMap00MapSize
  messageMap01Map: .incbin "out/maps/carderror_map01.bin" FSIZE messageMap01MapSize
  messageMap02Map: .incbin "out/maps/carderror_map02.bin" FSIZE messageMap02MapSize
  messageMap03Map: .incbin "out/maps/carderror_map03.bin" FSIZE messageMap03MapSize
  messageMap04Map: .incbin "out/maps/carderror_map04.bin" FSIZE messageMap04MapSize
  messageMap05Map: .incbin "out/maps/carderror_map05.bin" FSIZE messageMap05MapSize
  messageMap06Map: .incbin "out/maps/carderror_map06.bin" FSIZE messageMap06MapSize
  messageMap07Map: .incbin "out/maps/carderror_map07.bin" FSIZE messageMap07MapSize
  messageMap08Map: .incbin "out/maps/carderror_map08.bin" FSIZE messageMap08MapSize
  
  messageFrameDelayTable:
    ; 00
    .dw 453
    ; 01
    .dw 177
    ; 02
    .dw 289
    ; 03
    .dw 293
    ; 04
    .dw 189
    ; 05
    .dw 154
    ; 06
    .dw 282
    ; 07
    .dw 440
    ; 08
    .dw 164
  
  newScreenInit:
    ; make up work
;    jsr $441F
    
    ;================================
    ; load tile data
    ;================================
    
    ; src
    lda #<tileData
    sta _BL
    lda #>tileData
    sta _BH
    
    ; size
    lda #<tileDataSize
    sta _CL
    lda #>tileDataSize
    sta _CH
    
    ; dst
    lda #<tileDataLoadAddr
    sta _DL
    lda #>tileDataLoadAddr
    sta _DH
    
    jsr transferToVram
    
    jmp loadBgMap
  
  loadBgMap:
    ;================================
    ; load background map
    ;================================
    
    ; src
    lda #<messageBgMap
    sta _BL
    lda #>messageBgMap
    sta _BH
    
    ; size
    lda #<messageBgMapSize
    sta _CL
    lda #>messageBgMapSize
    sta _CH
    
    ; dst
    lda #<bgMapLoadAddr
    sta _DL
    lda #>bgMapLoadAddr
    sta _DH
    
    jmp transferToVram
  
  ; A = index of map
  loadMessageMap:
    ; use A as the high byte, effectively multiplying by 256
    ; add base address of maps
    clc
    adc #>messageMap00Map
    sta _BH
    lda #<messageMap00Map
    sta _BL
    
    ; size
    lda #<messageMap00MapSize
    sta _CL
    lda #>messageMap00MapSize
    sta _CH
    
    ; dst
    lda #<messageMapLoadAddr
    sta _DL
    lda #>messageMapLoadAddr
    sta _DH
    
    jmp transferToVram
  
  ; A = index of message
  runMessage:
    pha
      jsr loadMessageMap
      
      lda #<messageFrameDelayTable
      sta _BL
      lda #>messageFrameDelayTable
      sta _BH
    pla
    
    asl
    tay
    lda (_B),Y
    sta _AL
    iny
    lda (_B),Y
    sta _AH
    
    ; wait
    jmp waitFrames
  
  ; _A = frame count
  waitFrames:
    @loop:
      jsr waitForVsync
      lda _AL
      ora _AH
      beq @done
      
      sec
      lda _AL
      sbc #$01
      sta _AL
      lda _AH
      sbc #$00
      sta _AH
      jmp @loop
      
    @done:
    rts
  
  doSubtitles:
    ; do initial delay
    lda #75
    sta _AL
    stz _AH
    jsr waitFrames
    
    lda #$00
    @loop:
      pha
        jsr runMessage
      pla
      
      clc
      adc #$01
      cmp #$09
      bne @loop
    
    ; reload empty background
    jsr loadBgMap
    
    ; lock up
    -:
    jmp -
  
.ends


