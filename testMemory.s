/*
    TEST INFORMATION GOES HERE!
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
l100d   .byte   $21, $4e, $49, $54, $53, $55, $4a ; Store "!NITSUJ" in memory to be read backwards

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    jsr     $e55f           ; clear screen
    ldx     #$07            ; set x to 7 (7 characters in "!NITSUJ")

name:
    lda     l100d-1,x       ; reference name of memory <=> reference start of memory
    dex
    jsr     CHROUT
    bne     name
    rts
    end                     ; end of assembly code