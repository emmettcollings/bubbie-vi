Win:
    ldx     #$50
    lda     #$02
clearGameScreen:
    sta     frameBuffer0,x
    dex
    bpl     clearGameScreen

    lda     #$04
    sta     $fe
    jsr     UpdateTileShifting

    lda     #$60                        ; set the timer to 96 intervals of 2ms, or 192ms
    sta     $fd                       ; store our timer value

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
    sta     CLRMEM+$fc               ; MIDDLE

    lda     #$00                        ; Reset
    sta     OSC3

    lda     #$97                        ; D#
    sta     OSC1
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

    jmp     EndGameState