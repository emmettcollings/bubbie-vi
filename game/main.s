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
; Character Defintions
CHROUT = $ffd2                      ; kernal character output routine
CHRIN = $ffcf                       ; kernal character input routine

; Screen Defintions
SCRMEM = $1e00                      ; Screen memory address
CLRMEM = $9600                      ; Colour memory address 
HALF_SIZE = $0100                   ; Half the screen size

/*
    Main Routine
*/
    org     $1101                   ; mem location of code region
start:
    ; Initialize x to 0, and then jump to initiializeTitleScreen subroutine (titleScreen.s)
    ldx     #$00                    ; Initialize the counter
    jmp     initiializeTitleScreen

gameLoop:
    ; main game loop stuff
    rts

    include "titleScreen.s"               ; include the main program file