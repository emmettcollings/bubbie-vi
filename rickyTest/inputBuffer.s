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
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/* 
    Global Definitions
*/
; Routines
CHROUT = $ffd2              ; kernal character output routine

; Variables
INPUT_BUFFER = $1099        ; buffer for user input (arbitrary location)

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: ; we're gonna wait for a keypress (max 3 seconds) before we start
    ; clear screen
    lda     #$93            ; clear screen code
    jsr     CHROUT          ; write character to screen

readInput:
    lda     $c5             ; current key pressed

    ; if no key pressed, go back to readInput
    cmp     #$40
    beq     readInput

    ; if  'Q' is pressed, exit
    cmp     #$30
    beq     quit

    ; compare if the input is either, w, a, s, d and call the appropriate subroutine to move the character
    ; 'W' on keyboard (hex was found in mem @ $c5)
    cmp     #$09
    beq     quit

    ; 'A' on keyboard (hex was found in mem @ $c5)
    cmp     #$11
    beq     quit

    ; 'S' on keyboard (hex was found in mem @ $c5)
    cmp     #$29
    beq     quit

    ; 'D' on keyboard (hex was found in mem @ $c5)
    cmp     #$12
    beq     quit

    jmp     readInput

infiniteLoop:
    jmp     infiniteLoop

quit:
    ; we're done, so we'll just do nothing.
    rts
