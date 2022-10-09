/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1101           ; mem location of code region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Main Routine
*/
start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     $ffd2           ; call CHROUT (The KERNAL routine for printing a character)
    rts                     ; return to caller