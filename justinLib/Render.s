Render:
    lda     frameBuffer1+$1,x
    sta     $1ece,x

    lda     frameBuffer2+$1,x
    sta     $1ece+$16,x

    lda     frameBuffer3+$1,x
    sta     $1ece+$2c,x

    lda     frameBuffer4+$1,x
    sta     $1ece+$42,x

    lda     frameBuffer5+$1,x
    sta     $1ece+$58,x

    dex
    bpl     Render

    ldx     #$04
    dey
    bpl     Render