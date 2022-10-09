/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location of code region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

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
start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHROUT          ; call CHROUT
    rts                     ; return to caller