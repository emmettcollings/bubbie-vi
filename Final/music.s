playNote:
    lda     TEMP1
    sta     OSC2

    stx     $fd
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC2

    stx     $fd
    jsr     timer

    rts