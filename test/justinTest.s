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

P:
    lda     #$ff
    sta     $fc
    jsr     timer

    lda     $c5
    cmp     #$12
    beq     initD
    cmp     #$11
    beq     initA
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

initA:
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
    include "Decoder.s"