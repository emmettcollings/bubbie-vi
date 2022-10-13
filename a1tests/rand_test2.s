/*
    This test is for input detection.
    It will display another X to the screen every time a key is released AND THEN pressed.
*/

/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

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

/*
    Data
*/
l100d   .byte   $50, $52, $45, $53, $53, $20, $41, $4E, $59, $20, $4B, $45, $59

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    jsr     $e55f           ; clear screen
    ldx     #$00

name:
    lda     l100d-1,x       ; reference name of memory <=> reference start of memory
    inx
    jsr     CHROUT
    cpx     #$0e
    bne     name

nopress:
    lda     $cb
    cmp     #$40
    bne     nopress

press:
    lda     $cb
    cmp     #$40
    beq     press
    lda     #$58
    jsr     CHROUT
    jmp     nopress