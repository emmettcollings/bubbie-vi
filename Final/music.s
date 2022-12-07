playNote:
    lda     TEMP1
    sta     OSC2

    stx     TEMP3
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC2

    stx     TEMP3
    jsr     timer

    rts