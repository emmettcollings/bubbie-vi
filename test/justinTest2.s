/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.
    incdir "../justinLib"
/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

/* 
    Global Definitions
*/
CHROUT = $ffd2              ; kernal character output routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte


SCRMEM = $1e00                          ; Screen memory address
CLRMEM = $9600                          ; Colour memory address 
HALF = $100                             ; Half the screen size

/*
    Data
*/
    org     $1010
chr_1       .byte   $00, $3c, $26, $56, $56, $26, $3c, $24 ; amongus 2 1010
chr_blank   .byte   $00, $00, $00, $00, $00, $00, $00, $00 ; blank 3
chr_2       .byte   $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF ; wall 4 1020
chr_2_a     .byte   $00, $00, $00, $00, $00, $00, $00, $00 ; wallP 5
chr_wall_a  .byte   $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF ; wallC 6 1030
chr_wall_b  .byte   $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF ; wallCP 7
border      .byte   $aa, $00, $aa, $00, $aa, $00, $aa, $00 ; border 8 1040


    org     $1090
frameBuffer0    .byte   $04, $04, $04, $04, $04, $04, $04
frameBuffer1    .byte   $04, $04, $04, $03, $03, $04, $04
frameBuffer2    .byte   $04, $04, $03, $04, $03, $04, $04
frameBuffer3    .byte   $04, $03, $03, $03, $03, $03, $04
frameBuffer4    .byte   $04, $03, $04, $03, $04, $03, $04
frameBuffer5    .byte   $04, $04, $04, $03, $04, $04, $04
frameBuffer6    .byte   $04, $04, $04, $04, $04, $04, $04

/*
    Main Routine
*/
    org     $1101               ; mem location of code region
start: 
    ldx     #$00                ; Initialize the counter
initializeScreen:    
    lda     #$03                ; Load a with 'space' to fill the screen with
    sta     SCRMEM,X            ; Write to the first half of the screen memory
    sta     SCRMEM+HALF,X       ; Write to the second half of the screen memory

    lda     #$06                        ; Load a with the colour of the characters to be displayed (blue)
    sta     CLRMEM,X                    ; Write to the first half of the colour memory
    sta     CLRMEM+HALF,X          ; Write to the second half of the colour memory
    inx

    bne     initializeScreen    ; Loop until the counter overflows back to 0, then exit the loop
    
    lda     #$fc            
    sta     $9005               ; load custom character set

    lda     #$02
    sta     $1efc               ; MIDDLE

    ldx     #$00
topRowWall:
    lda     #$06
    sta     $1e00,x
    lda     #$07
    sta     $1e01,x
    inx
    cpx     #$15
    bne     topRowWall

    lda     #$08
    ;TOP
    sta     $1eb7               ; TOP LEFT CORNER
    sta     $1eb7+$1
    sta     $1eb7+$2
    sta     $1eb7+$3
    sta     $1eb7+$4
    sta     $1eb7+$5
    sta     $1eb7+$6

    ;LEFT SIDE
    sta     $1eb7+$16
    sta     $1eb7+$2c
    sta     $1eb7+$42
    sta     $1eb7+$58
    sta     $1eb7+$6e
    sta     $1eb7+$84

    ;BOTTOM
    sta     $1eb7+$84+$1
    sta     $1eb7+$84+$2
    sta     $1eb7+$84+$3
    sta     $1eb7+$84+$4
    sta     $1eb7+$84+$5
    sta     $1eb7+$84+$6

    ;RIGHT SIDE
    sta     $1eb7+$6+$16
    sta     $1eb7+$6+$2c
    sta     $1eb7+$6+$42
    sta     $1eb7+$6+$58
    sta     $1eb7+$6+$6e

    ldx     #$4
LPO1:
    lda     frameBuffer1+$1,x
    sta     $1ece,x
    dex
    bpl     LPO1

    ldx     #$4
LPO2:
    lda     frameBuffer2+$1,x
    sta     $1ece+$16,x
    dex
    bpl     LPO2

    ldx     #$4
LPO3:
    cpx     #$2
    bne     LPO3_A
    dex
    jmp     LPO3
LPO3_A:
    lda     frameBuffer3+$1,x
    sta     $1ece+$2c,x
    dex
    bpl     LPO3

    ldx     #$4
LPO4:
    lda     frameBuffer4+$1,x
    sta     $1ece+$42,x
    dex
    bpl     LPO4

    ldx     #$4
LPO5:
    lda     frameBuffer5+$1,x
    sta     $1ece+$58,x
    dex
    bpl     LPO5

P:
    lda     #$ff
    sta     $fc
    jsr     timer

    lda     $c5
    cmp     #$12
    beq     initD
    cmp     #$11
    beq     initL1
    jmp     P

   ; pla
initD:
    ldx     #$08
    stx     $fe
loopD:
    lda     #$6a
    sta     $fb
    lda     #$20
    sta     $fc
    lda     #$10
    sta     $fd
    jsr     charShift_H

    lda     #$30
    sta     $fc
    jsr     charShift_H

    lda     #$40
    sta     $fc
    jsr     timer

    dec     $fe
    bne     loopD

    jmp     P                   ; jump to main routine

initL1:
    lda     frameBuffer1+$6
    sta     $fe
    ldx     #$04
SL1:
    lda     frameBuffer1+$1,x
    cmp     $fe
    sta     $fe
    bne     screenShift_L_A1
    lda     #$06
    sta     $1eb7+$16+$1,x
    jmp     screenShift_L_B1
screenShift_L_A1:
    cmp     #$03
    bne     screenShift_L_C1
    lda     #$05
    sta     $1eb7+$16+$1,x
    jmp     screenShift_L_B1
screenShift_L_C1:
    lda     #$04
    sta     $1eb7+$16+$1,x
screenShift_L_B1:
    dex
    bpl     SL1

initL2:
    lda     frameBuffer2+$6
    sta     $fe
    ldx     #$04
SL2:
    lda     frameBuffer2+$1,x
    cmp     $fe
    sta     $fe
    bne     screenShift_L_A2
    lda     #$06
    sta     $1eb7+$2c+$1,x
    jmp     screenShift_L_B2
screenShift_L_A2:
    cmp     #$03
    bne     screenShift_L_C2
    lda     #$05
    sta     $1eb7+$2c+$1,x
    jmp     screenShift_L_B2
screenShift_L_C2:
    lda     #$04
    sta     $1eb7+$2c+$1,x
screenShift_L_B2:
    dex
    bpl     SL2

; initL3:
;     lda     frameBuffer3+$6
;     sta     $fe
;     ldx     #$04
; SL3:
;     lda     frameBuffer3+$1,x
;     cmp     $fe
;     sta     $fe
;     bne     screenShift_L_A3
;     lda     #$06
;     sta     $1eb7+$42+$1,x
;     jmp     screenShift_L_B3
; screenShift_L_A3:
;     cmp     #$03
;     bne     screenShift_L_C3
;     lda     #$05
;     sta     $1eb7+$42+$1,x
;     jmp     screenShift_L_B3
; screenShift_L_C3:
;     lda     #$04
;     sta     $1eb7+$42+$1,x
; screenShift_L_B3:
;     dex
;     bpl     SL3

initL4:
    lda     frameBuffer4+$6
    sta     $fe
    ldx     #$04
SL4:
    lda     frameBuffer4+$1,x
    cmp     $fe
    sta     $fe
    bne     screenShift_L_A4
    lda     #$06
    sta     $1eb7+$58+$1,x
    jmp     screenShift_L_B4
screenShift_L_A4:
    cmp     #$03
    bne     screenShift_L_C4
    lda     #$05
    sta     $1eb7+$58+$1,x
    jmp     screenShift_L_B4
screenShift_L_C4:
    lda     #$04
    sta     $1eb7+$58+$1,x
screenShift_L_B4:
    dex
    bpl     SL4

initL5:
    lda     frameBuffer5+$6
    sta     $fe
    ldx     #$04
SL5:
    lda     frameBuffer5+$1,x
    cmp     $fe
    sta     $fe
    bne     screenShift_L_A5
    lda     #$06
    sta     $1eb7+$6e+$1,x
    jmp     screenShift_L_B5
screenShift_L_A5:
    cmp     #$03
    bne     screenShift_L_C5
    lda     #$05
    sta     $1eb7+$6e+$1,x
    jmp     screenShift_L_B5
screenShift_L_C5:
    lda     #$04
    sta     $1eb7+$6e+$1,x
screenShift_L_B5:
    dex
    bpl     SL5

    ldx     #$08
    stx     $fe
loopA:
    lda     #$2a
    sta     $fb
    lda     #$20
    sta     $fc
    lda     #$10
    sta     $fd
    jsr     charShift_H

    lda     #$30
    sta     $fc
    jsr     charShift_H

    lda     #$40
    sta     $fc
    jsr     timer

    dec     $fe
    bne     loopA


    jmp     P                   ; jump to main routine


    include "CharacterMovement.s"
    include "Timer.s"