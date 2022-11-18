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
COUNTER_Y = $109A           ; counter for y

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: ; we're gonna wait for a keypress (max 3 seconds) before we start
    ; clear screen
    lda     #$93            ; clear screen code
    jsr     CHROUT          ; write character to screen

    ldx     #$ff            ; set up counter

    lda     #$00            ; set up counter
    sta     COUNTER_Y       ; set up counter

    jmp     readInput

updateCounter:
    ldx     #$ff            ; set up counter

    inc     COUNTER_Y       ; increment counter
    ldy     COUNTER_Y       ; check if counter is zero
    cpy     #$ff              ; check if counter is zero
    beq     movementLoop    ; if so, jump to movement loop

readInput:
    dex                     ; decrement counter
    cpx     #0              ; check if counter is zero
    beq     updateCounter   ; if so, update counter and continue

    lda     $c5             ; current key pressed
    cmp     #$40            
    beq     readInput 

    sta     INPUT_BUFFER    ; store key in buffer
    jmp     readInput

movementLoop:
    lda     INPUT_BUFFER    ; load key from buffer

    ; if 'Q' is pressed, exit
    cmp     #$30
    beq     quit

    ; compare if the input is either, w, a, s, d and call the appropriate subroutine to move the character
    ; 'W' on keyboard
    cmp     #$09
    beq     moveUp

    ; 'A' on keyboard
    cmp     #$11
    beq     moveLeft

    ; 'S' on keyboard
    cmp     #$29
    beq     moveDown

    ; 'D' on keyboard
    cmp     #$12
    beq     moveRight

reset:
    lda     #$00            ; set up counter
    sta     INPUT_BUFFER    ; set up counter
    sta     COUNTER_Y       ; set up counter
    ldx     #$ff            ; set up counter

    jmp     readInput

/*
    code below is kinda messy, but it works. 
    i know there's a better way to do this, but i'm not sure how to do it yet (way to late to think of a solution for making it shorter, will do it for the final version)
*/
moveUp:
    lda     #$88
    sta     $fb
    ; jsr     charShift_V
    jmp     reset

moveLeft:
    lda     #$2a
    sta     $fb
    ; jmp     charShift_H
    jmp     reset

moveDown:
    lda     #$c8
    sta     $fb
    ; jsr     charShift_V
    jmp     reset

moveRight:
    lda     #$6a
    sta     $fb
    ; jmp     charShift_H
    jmp     reset

quit:
    ; we're done, so we'll just exit
    rts