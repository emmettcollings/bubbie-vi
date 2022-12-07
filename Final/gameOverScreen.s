GameOver:
    lda     #$01                        ; set the volume of the oscillators to 1
    sta     OSCVOL


    lda     #$a7                        ; F#
    sta     OSC3
    
    stx     $fd                       ; store our timer value
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

DeathSequence:
    lda     #$04
    sta     $8e
    asl
    sta     $8c
    dec     $fd
    jsr     timer
    dec     $fd
    jsr     timer
    lda     #$00                        ; Reset
    sta     OSC1
FlailLoopSink:
    dec     $8e
    bne     FlailLoopFlip
    lda     #$04
    sta     $8e
    lda     #$c8
    sta     TEMP1
    jsr     load10
    jsr     charShift_V
    dec     $8c
    beq     EndGameState
FlailLoopFlip:
    jsr     wait60
    jsr     load10
    
    jsr     characterFlip
    jmp     FlailLoopSink
EndGameState:
    jmp     EndGameState