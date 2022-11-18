initSSR_U:
    ldy     #$04
screenShiftRight_U:
    ; Should never reach here
    lda     frameBuffer0+$1
    sta     $fb
    ldx     #$58
sSRLoop_U:
    lda     frameBuffer1+$1,x
    sta     $fc
    cmp     #$03
    beq     S20_U
    cmp     #$04
    beq     S40_U
    ; Should never reach here
S20_U:
    lda     $fb
    cmp     #$03
    beq     S22_U
    cmp     #$04
    beq     S24_U
    ; Should never reach here
S40_U:
    lda     $fb
    cmp     #$03
    beq     S42_U
    cmp     #$04
    beq     S44_U
    ; Should never reach here

S22_U:
    lda     #$06
    jmp     endLoop_U
S24_U:
    lda     #$0b
    jmp     endLoop_U
S42_U:
    lda     #$0a
    jmp     endLoop_U
S44_U:
    lda     #$08
    jmp     endLoop_U
endLoop_U:
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
    bmi     initD_p_U
    jmp     sSRLoop_U
initD_p_U:

    dey
    bmi     initD_U
    jmp     screenShiftRight_U
initD_U:
    lda     #$02
    sta     $1efc               ; MIDDLE
    ldx     #$08
    stx     $fe

    lda     #$c8
    sta     $fb