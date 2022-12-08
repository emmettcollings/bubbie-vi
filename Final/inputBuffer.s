; Variables
INPUT_BUFFER = TEMP1                    ; buffer for user input (arbitrary location)
COUNTER_Y = TEMP2                       ; counter for y

inputLoop: ; we're gonna wait for a keypress (max 3 seconds) before we start
    lda     #$00                        ; set up counter
    sta     INPUT_BUFFER                ; set up counter
    sta     COUNTER_Y                   ; set up counter
    ldx     #$ff                        ; set up counter

    jmp     readInput

updateCounter:
    ldx     #$2f                        ; set up counter

    inc     COUNTER_Y                   ; increment counter
    ldy     COUNTER_Y                   ; check if counter is zero
    cpy     #$ff                        ; check if counter is zero
    bne     readInput                   ; if so, jump to movement loop
    jmp     movementLoop
readInput:
    dex                                 ; decrement counter
    cpx     #0                          ; check if counter is zero
    beq     updateCounter               ; if so, update counter and continue

    lda     $c5                         ; current key pressed
    cmp     #$40            
    beq     readInput 

    sta     INPUT_BUFFER                ; store key in buffer
    jmp     readInput
    
moveDown:
    lda     frameBuffer5+$04
    cmp     #$02
    beq     continueDown
    cmp     #$08
    beq     continueDown
    cmp     #$05
    beq     GetChest_M
    cmp     #$04
    beq     downKill
    jmp     CollisionReset
downKill:
    jsr     killEnemySound
    lda     #$02
    sta     frameBuffer5+$04
    jmp     CollisionReset

continueDown:
    inc     PY

    ldx     #$02
    stx     TEMP4
    jsr     UpdateTileShifting

    lda     #$88
    sta     TEMP1
    jmp     VerticalRender

moveUp:
    lda     frameBuffer3+$04
    cmp     #$02
    beq     continueUp
    cmp     #$08
    beq     continueUp
    cmp     #$05
    beq     GetChest_M
    cmp     #$04
    beq     upKill
    jmp     CollisionReset
upKill:
    jsr     killEnemySound
    lda     #$02
    sta     frameBuffer3+$04
    jmp     CollisionReset

continueUp:
    dec     PY

    ldx     #$03
    stx     TEMP4
    jsr     UpdateTileShifting
    lda     #$c8
    sta     TEMP1
    jmp     VerticalRender

GetChest_M:
    lda     duckFlag
    bne     CollisionReset
    inc     duckFlag
    inc     duckData
    lda     flagData
    eor     #%00000001
    sta     flagData
    jmp     CharDoneMoving

movementLoop:
    lda     INPUT_BUFFER                ; load key from buffer

    ; compare if the input is either, w, a, s, d and call the appropriate subroutine to move the character
    ; 'W' on keyboard
    cmp     #$09
    beq     moveUp

    ; 'A' on keyboard
    cmp     #$11
    beq     moveLeft

    ; 'S' on keyboard
    cmp     #$29
    bne     checkD
    jmp     moveDown

checkD:
    ; 'D' on keyboard
    cmp     #$12
    bne     CollisionReset
    jmp     moveRight

CollisionReset:
    jmp     readInput

killEnemySound:
    lda     #$80                        ; B
    sta     OSC1
    lda     #$87                        ; C
    sta     OSC2
    stx     TEMP3                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC1
    sta     OSC2
    rts

VerticalRender:
    lda     #$02
    sta     SCRMEM+TEMP2                ; MIDDLE
    lda     #$07
    sta     TEMP4
ShiftEverything_V1:
    lda     #$10
    sta     TEMP3
    lda     #$d0
ShiftEverything_V2:
    sta     TEMP2
    jsr     charShift_V
    lda     TEMP2
    sec
    sbc     #$10
    cmp     #$20                        ; Saves time over $10 since blank doesn't need to be shifted
    bne     ShiftEverything_V2

    lda     #$f0
    sta     TEMP2
    jsr     charShift_V

    lda     #$28
    sta     TEMP3
    jsr     timer
    dec     TEMP4 
    bpl     ShiftEverything_V1

ShiftEverything_V3:
    lda     TEMP1
    cmp     #$c8
    bne     ShiftEverything_V4
    lda     #$02
    sta     TEMP7
    jsr     MoveEnemies
    jmp     CharDoneMoving
ShiftEverything_V4:
    lda     #$03
    sta     TEMP7
    jsr     MoveEnemies
    jmp     CharDoneMoving

GetChest:
    jmp     GetChest_M

moveLeft:
    lda     frameBuffer4+$03
    cmp     #$02
    beq     continueLeft
    cmp     #$08
    beq     continueLeft
    cmp     #$05
    beq     GetChest
    cmp     #$04
    beq     leftKill
    jmp     CollisionReset
leftKill:
    jsr     killEnemySound
    lda     #$02
    sta     frameBuffer4+$03
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
    sta     TEMP3
    sta     TEMP2
    jsr     characterFlip
skipFlipLeft:
    dec     PX

    ldx     #$00
    stx     TEMP4
    jsr     UpdateTileShifting

    lda     #$6a
    sta     TEMP1
    jmp     HorizontalRender

moveRight:
    lda     frameBuffer4+$05
    cmp     #$02
    beq     continueRight
    cmp     #$08
    beq     continueRight
    cmp     #$05
    beq     GetChest
    cmp     #$04
    beq     rightKill
    jmp     CollisionReset
rightKill:
    jsr     killEnemySound
    lda     #$02
    sta     frameBuffer4+$05
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
    sta     TEMP3
    sta     TEMP2
    jsr     characterFlip

skipFlipRight:
    inc     PX

    ldx     #$01
    stx     TEMP4
    jsr     UpdateTileShifting

    lda     #$2a
    sta     TEMP1

HorizontalRender:
    lda     #$02
    sta     SCRMEM+TEMP2               ; MIDDLE
    lda     #$07
    sta     TEMP4
ShiftEverything_H1:
    lda     #$10
    sta     TEMP3
    lda     #$d0
ShiftEverything_H2:
    sta     TEMP2
    jsr     charShift_H
    lda     TEMP2
    sec
    sbc     #$10
    cmp     #$20                        ; Saves time over $10 since blank doesn't need to be shifted
    bne     ShiftEverything_H2

    lda     #$f0
    sta     TEMP2
    jsr     charShift_H

    lda     #$28
    sta     TEMP3
    jsr     timer
    dec     TEMP4 
    bpl     ShiftEverything_H1

ShiftEverything_H3:
    lda     TEMP1
    cmp     #$2a
    bne     ShiftEverything_H4
    lda     #$00
    sta     TEMP7
    jsr     MoveEnemies
    jmp     CharDoneMoving
ShiftEverything_H4:
    lda     #$01
    sta     TEMP7
    jsr     MoveEnemies
    jmp     CharDoneMoving
