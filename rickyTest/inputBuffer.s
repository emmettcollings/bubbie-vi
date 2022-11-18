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

noInput:
    lda     INPUT_BUFFER
    jsr     CHROUT

    ; track that this has been called
    ; if we're at 3 seconds since the last keypress, we'll load the last key into the accumulator and jump to the movementLoop

    lda     INPUT_BUFFER
    jmp     movementLoop

readInput:
    lda     $c5             ; current key pressed

    ; if no key pressed, go back to readInput
    cmp     #$40
    beq     noInput 

    sta     INPUT_BUFFER    ; store key in buffer

    ; if 'Q' is pressed, exit
    cmp     #$30
    beq     quit

movementLoop:
    ; compare if the input is either, w, a, s, d and call the appropriate subroutine to move the character
    ; 'W' on keyboard (hex was found in mem @ $c5)
    cmp     #$09
    beq     moveUp

    ; 'A' on keyboard (hex was found in mem @ $c5)
    cmp     #$11
    beq     moveLeft

    ; 'S' on keyboard (hex was found in mem @ $c5)
    cmp     #$29
    beq     moveDown

    ; 'D' on keyboard (hex was found in mem @ $c5)
    cmp     #$12
    beq     moveRight

    jmp     readInput

/*
    code below is kinda messy, but it works. 
    i know there's a better way to do this, but i'm not sure how to do it yet (way to late to think of a solution for making it shorter, will do it for the final version)
*/
moveUp:
    lda     #$88
    sta     $fb
    ; jsr     charShift_V
    rts

moveLeft:
    lda     #$2a
    sta     $fb
    ; jmp     charShift_H
    rts

moveDown:
    lda     #$c8
    sta     $fb
    ; jsr     charShift_V
    rts

moveRight:
    lda     #$6a
    sta     $fb
    ; jmp     charShift_H
    rts

infiniteLoop:
    jmp     infiniteLoop

quit:
    ; we're done, so we'll just exit
    rts