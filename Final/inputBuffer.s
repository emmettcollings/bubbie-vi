; Variables
INPUT_BUFFER = $fb        ; buffer for user input (arbitrary location)
COUNTER_Y = $fc           ; counter for y

inputLoop: ; we're gonna wait for a keypress (max 3 seconds) before we start
    lda     #$00            ; set up counter
    sta     INPUT_BUFFER    ; set up counter
    sta     COUNTER_Y       ; set up counter
    ldx     #$ff            ; set up counter

    jmp     readInput

updateCounter:
    ldx     #$4f            ; set up counter

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

    ; LEFT: X = 3d, Y = 8a, $8d = 00
    ; RIGHT: X = 01, Y = 00, $8d = 7f
    ; UP: X = 0a, Y = 00
    ; DOWN: X = 46, Y = 8a
    
moveDown:
    lda     frameBuffer5+$04
    cmp     #$02
    beq     continueDown
    cmp     #$08
    beq     continueDown
    jmp     CollisionReset

continueDown:
    inc     PY
    ldx     #$0a
    ldy     #$00

    jsr     MoveUp
    lda     #$88
    sta     $fb
    jmp     VerticalRender

moveUp:
    lda     frameBuffer3+$04
    cmp     #$02
    beq     continueUp
    cmp     #$08
    beq     continueUp
    jmp     CollisionReset

continueUp:
    dec     PY
    ldx     #$46
    ldy     #$8a

    jsr     MoveDown
    lda     #$c8
    sta     $fb

VerticalRender:
    lda     #$02
    sta     $1efc               ; MIDDLE
    lda     #$07
    sta     $fe
ShiftEverything_V1:
    lda     #$10
    sta     $fd
    lda     #$d0
ShiftEverything_V2:
    sta     $fc
    jsr     charShift_V
    lda     $fc
    sec
    sbc     #$10
    cmp     #$20                ; Saves time over $10 since blank doesn't need to be shifted
    bne     ShiftEverything_V2

    lda     #$f0
    sta     $fc
    jsr     charShift_V

    lda     #$28
    sta     $fd
    jsr     timer
    dec     $fe 
    bpl     ShiftEverything_V1
    jmp     CharDoneMoving

movementLoop:
    lda     INPUT_BUFFER    ; load key from buffer

    ; ; if 'Q' is pressed, exit
    ; cmp     #$30
    ; beq     quit

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

CollisionReset:
    jmp     readInput

moveLeft:
    lda     frameBuffer4+$03
    cmp     #$02
    beq     continueLeft
    cmp     #$08
    beq     continueLeft
    jmp     CollisionReset

continueLeft:
    lda     flagData
    tax
    asl
    txa
    and     #$7f
    sta     flagData
    bcc     skipFlipLeft

    lda     #$10
    sta     $fd
    sta     $fc
    jsr     characterFlip
skipFlipLeft:
    dec     PX
    ldx     #$3d
    ldy     #$8a
    lda     #$00
    sta     $8d

    jsr     MoveHorizontal
    lda     #$6a
    sta     $fb
    jmp     HorizontalRender

moveRight:
    lda     frameBuffer4+$05
    cmp     #$02
    beq     continueRight
    cmp     #$08
    beq     continueRight
    jmp     CollisionReset

continueRight:
    lda     flagData
    tax
    asl
    txa
    ora     #$80
    sta     flagData
    bcs     skipFlipRight

    lda     #$10
    sta     $fd
    sta     $fc
    jsr     characterFlip

skipFlipRight:
    inc     PX
    ldx     #$01
    ldy     #$00
    lda     #$7f
    sta     $8d

    jsr     MoveHorizontal
    lda     #$2a
    sta     $fb

HorizontalRender:
    lda     #$02
    sta     $1efc               ; MIDDLE
    lda     #$07
    sta     $fe
ShiftEverything_H1:
    lda     #$10
    sta     $fd
    lda     #$d0
ShiftEverything_H2:
    sta     $fc
    jsr     charShift_H
    lda     $fc
    sec
    sbc     #$10
    cmp     #$20                ; Saves time over $10 since blank doesn't need to be shifted
    bne     ShiftEverything_H2

    lda     #$f0
    sta     $fc
    jsr     charShift_H

    lda     #$28
    sta     $fd
    jsr     timer
    dec     $fe 
    bpl     ShiftEverything_H1
    jmp     CharDoneMoving

quit:
    ; we're done, so we'll just exit
    rts
