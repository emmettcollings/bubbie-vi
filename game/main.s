/*
    Processor Information
*/
    processor   6502                ; This informs the assembler that we are using a 6502 processor.
    incdir      "./"                ; This tells the assembler to look in the current directory for include files.
    incdir      "../justinLib"     ; This tells the assembler to look in the JustinLib directory for include files.
    incdir      "../lib"

/*
    Memory Map
*/
    org     $1001                   ; mem location of user region
    dc.w    stubend
    dc.w    1                       ; arbitrary line number for BASIC syntax
    dc.b    $9e, "5682", 0          ; allocate bytes. 5898 = 170a

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

; we've got to import this here, as its location is before the main routine start. 
; we will be cleaning up the memory locations later, as we finalize the code.
    include "game.s"                ; include the game file

/*
    Main Routine
*/
    org     $1632                   ; mem location of code region
start:
    lda     #$10
    sta     PX
    sta     PY

    jsr     loadDisplay

    ; Initialize x to 0, and then jump to initiializeTitleScreen subroutine (titleScreen.s)
    ldx     #$00                    ; Initialize the counter
    jmp     initiializeTitleScreen

gameLoop:
    ; main game loop stuff
    jmp     startRender
    rts

    include "Decoder.s"
    include "loadDisp.s"
    include "titleScreen.s"               ; include the main program file
    include "inputBuffer.s"

    org     $183f
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
    dc.b $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
