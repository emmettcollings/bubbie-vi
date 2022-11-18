initSSR_D:
    lda     #$04
    sta     $fd
screenShiftRight_D:
    ; Should never reach here
    lda     frameBuffer6+$1
    sta     $fb
    ldx     #$58
    ldy     #$1c
sSRLoop_D:
    lda     frameBuffer1+$1,y
    sta     $fc
    cmp     #$03
    beq     S20_D
    cmp     #$04
    beq     S40_D
    ; Should never reach here
S20_D:
    lda     $fb
    cmp     #$03
    beq     S22_D
    cmp     #$04
    beq     S24_D
    ; Should never reach here
S40_D:
    lda     $fb
    cmp     #$03
    beq     S42_D
    cmp     #$04
    beq     S44_D
    ; Should never reach here

S22_D:
    lda     #$06
    jmp     endLoop_D
S24_D:
    lda     #$0b
    jmp     endLoop_D
S42_D:
    lda     #$0a
    jmp     endLoop_D
S44_D:
    lda     #$08
    jmp     endLoop_D
endLoop_D:
    sta     $1ece,x
    lda     $fc
    sta     $fb

    dex
    dex
    dex
    dex
    dex

    dex
    dex
    dex
    dex
    dex   

    dex
    dex
    dex
    dex
    dex

    dex
    dex
    dex
    dex
    dex
    dex

    dex

    dey
    dey
    dey
    dey
    dey
    dey
    dey

    bmi     initD_p_D
    jmp     sSRLoop_D
initD_p_D:

    ; dey
    ; bmi     initD_D
    ; jmp     screenShiftRight_D
initD_D:
    lda     #$02
    sta     $1efc               ; MIDDLE
    ldx     #$08
    stx     $fe

    lda     #$88
    sta     $fb