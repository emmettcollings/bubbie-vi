GameOver:
    ldx     #$60                        ; set the timer to 96 intervals of 2ms, or 192ms

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
    stx     $fd                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC1

    lda     #$80                        ; B
    sta     OSC3
    stx     $fd                       ; store our timer value
    jsr     timer

    lda     #$02
    sta     CLRMEM+$fc               ; MIDDLE

    lda     #$00                        ; Reset
    sta     OSC3

    lda     #$97                        ; D#
    sta     OSC1
    stx     $fd                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC1

    lda     #$80                        ; B
    sta     OSC1

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
    sta     $fb
    lda     #$10
    sta     $fd
    sta     $fc
    jsr     charShift_V
    dec     $8c
    beq     EndGameState
FlailLoopFlip:
    lda     #$60
    sta     $fd
    jsr     timer

    lda     #$10
    sta     $fd
    sta     $fc
    jsr     characterFlip
    jmp     FlailLoopSink
EndGameState:
    jmp     EndGameState