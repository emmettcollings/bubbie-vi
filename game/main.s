/*
    Processor Information
*/
    processor   6502                ; This informs the assembler that we are using a 6502 processor.
    incdir      "./"                ; This tells the assembler to look in the current directory for include files.

/*
    Memory Map
*/
    org     $1001                   ; mem location of user region
    dc.w    stubend
    dc.w    1                       ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0          ; allocate bytes. 4353 = 1101

/*
    Utility Routines
*/
stubend:
    dc.w    0                       ; insert null byte

/* 
    Global Definitions
*/
CHROUT = $ffd2                      ; kernal character output routine

/*
    Main Routine
*/
    org     $1101                   ; mem location of code region
start:
    ; do any initialization here, before calling the other files.
    ldx     #$00                    ; Initialize the counter
    jmp     initiializeTitleScreen
    rts

    include "title.s"               ; include the main program file