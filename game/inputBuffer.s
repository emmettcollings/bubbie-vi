; Variables
INPUT_BUFFER = $1099        ; buffer for user input (arbitrary location)
COUNTER_Y = $109A           ; counter for y

inputLoop: ; we're gonna wait for a keypress (max 3 seconds) before we start
    lda     #$00            ; set up counter
    sta     INPUT_BUFFER    ; set up counter
    sta     COUNTER_Y       ; set up counter
    ldx     #$ff            ; set up counter

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

    jmp     readInput

moveUp:
    jsr     loadDisplay
    dec     PY
    jmp     initSSR_U

moveLeft:
    lda     #$10
    sta     $fc
    sta     $fd
    lda     $1a01
    cmp     #$00
    beq     mL
    jsr     characterFlip
mL:
    lda     #$00
    sta     $1a01
    jsr     loadDisplay
    dec     PX
    jmp     initSSR_L

moveDown:
    jsr     loadDisplay
    inc     PY
    jmp     initSSR_D

moveRight:
    lda     #$10
    sta     $fc
    sta     $fd
    lda     $1a01
    cmp     #$01
    beq     mR
    jsr     characterFlip
mR:
    lda     #$01
    sta     $1a01
    jsr     loadDisplay
    inc     PX
    jmp     initSSR_R

quit:
    ; we're done, so we'll just exit
    rts