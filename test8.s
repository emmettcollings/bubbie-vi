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
CHROUT = $ffd2          ; kernal character output routine 

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    jmp     checkInput      ; jump to checkInput routine
    rts                     ; return to caller

/*
    Check Input Routine
*/
checkInput:
    ; get num from 00c5, if its 64 then jump to checkInput again. 
    ; otherwise, jump to printChar routine.
    lda     $00c5
    cmp     #$40
    beq     checkInput
    jsr     printChar
    jmp     checkInput      ; jump to checkInput routine

printChar:
    ; print the character in $00c5
    lda     $00c5
    jsr     CHROUT
    rts