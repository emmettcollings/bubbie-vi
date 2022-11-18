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
    dc.b    $00, $3c, $26, $56, $56, $26, $3c, $24  ; Amongus 2
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank 3
    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall 4

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1 5
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2 6

    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall1 7
    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall2 8

    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall1B 9
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2B 10

    dc.b    $aa, $00, $aa, $00, $aa, $00, $aa, $00  ; Border 11



    org     $1090
frameBuffer0    .byte   $04, $04, $04, $04, $04, $04, $04
frameBuffer1    .byte   $04, $04, $04, $04, $03, $04, $04
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
    lda     #$fc            
    sta     $9005               ; load custom character set

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

    ; TODO: simplify
    lda     #$0b
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

    ldx     #$04
    ldy     #$04

    include "Render.s"

    lda     #$02
    sta     $1efc               ; MIDDLE

S:
    lda     #$ff
    sta     $fc
    jsr     timer

    lda     $c5
    cmp     #$12
    beq     shiftRightJMP
    cmp     #$11
    beq     shiftLeftJMP
    jmp     S
shiftRightJMP:
    jmp     initSSR_R
shiftLeftJMP:
    jmp     initSSR_L

    include "MoveRight.s"
    jmp     loopD
    include "MoveLeft.s"

loopD:
    lda     #$38
    sta     $fc
    lda     #$10
    sta     $fd
    jsr     charShift_H

    lda     #$48
    sta     $fc
    jsr     charShift_H

    lda     #$30
    sta     $fd
    jsr     timer

    dec     $fe
    bne     loopD

    jmp     S                   ; jump to main routine


    include "CharacterMovement.s"
    include "Timer.s"