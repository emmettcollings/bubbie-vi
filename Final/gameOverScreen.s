/*
    Game Over Screen
*/
GameOver: ; Play the game over music.
    lda     #$01                        ; set the volume of the oscillators to 1
    sta     OSCVOL

    lda     #$a7                        ; F#
    sta     OSC3
    
    stx     TEMP3                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC3

    lda     #$97                        ; D#
    sta     OSC1
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC1

    lda     #$80                        ; B
    sta     OSC3
    jsr     timer

    lda     #$02
    sta     CLRMEM+TEMP2                ; MIDDLE

    lda     #$00                        ; Reset
    sta     OSC3

    lda     #$97                        ; D#
    sta     OSC1
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC1

    lda     #$80                        ; B
    sta     OSC1

DeathSequence: ; Play the death sequence (The tombstone crushing the player)
    lda     #$04
    sta     TEMP8
    asl
    sta     TEMP6
    dec     TEMP3
    jsr     timer
    dec     TEMP3
    jsr     timer
    lda     #$00                        ; Reset
    sta     OSC1

FlailLoopSink:
    dec     TEMP8
    bne     FlailLoopFlip
    lda     #$04
    sta     TEMP8
    lda     #$c8
    sta     TEMP1
    jsr     load10
    jsr     charShift_V
    dec     TEMP6
    beq     EndGameState

FlailLoopFlip:
    jsr     wait60
    jsr     load10
    
    jsr     characterFlip
    jmp     FlailLoopSink

EndGameState:
    jmp     EndGameState