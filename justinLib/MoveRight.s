initSSR_R:
    ldy     #$04
screenShiftRight_R:
    cpy     #$00
    beq     IFB1_R
    cpy     #$01
    beq     IFB2_R
    cpy     #$02
    beq     IFB3_R
    cpy     #$03
    beq     IFB4_R
    cpy     #$04
    beq     IFB5_R
    ; Should never reach here
IFB1_R:
    lda     frameBuffer1+$6
    jmp     IFB_R
IFB2_R:
    lda     frameBuffer2+$6
    jmp     IFB_R
IFB3_R:
    lda     frameBuffer3+$6
    jmp     IFB_R
IFB4_R:
    lda     frameBuffer4+$6
    jmp     IFB_R
IFB5_R:
    lda     frameBuffer5+$6
    jmp     IFB_R
IFB_R:
    sta     $fb
    ldx     #$04
sSRLoop_R:
    cpy     #$00
    beq     IFC1_R
    cpy     #$01
    beq     IFC2_R
    cpy     #$02
    beq     IFC3_R
    cpy     #$03
    beq     IFC4_R
    cpy     #$04
    beq     IFC5_R
    ; Should never reach here
IFC1_R:
    lda     frameBuffer1+$1,x
    jmp     IFC_R
IFC2_R:
    lda     frameBuffer2+$1,x
    jmp     IFC_R
IFC3_R:
    lda     frameBuffer3+$1,x
    jmp     IFC_R
IFC4_R:
    lda     frameBuffer4+$1,x
    jmp     IFC_R
IFC5_R:
    lda     frameBuffer5+$1,x
    jmp     IFC_R

IFC_R:
    sta     $fc
    cmp     #$03
    beq     S20_R
    cmp     #$04
    beq     S40_R
    ; Should never reach here
S20_R:
    lda     $fb
    cmp     #$03
    beq     S22_R
    cmp     #$04
    beq     S24_R
    ; Should never reach here
S40_R:
    lda     $fb
    cmp     #$03
    beq     S42_R
    cmp     #$04
    beq     S44_R
    ; Should never reach here

S22_R:
    lda     #$05
    jmp     endLoop_R
S24_R:
    lda     #$0a
    jmp     endLoop_R
S42_R:
    lda     #$09
    jmp     endLoop_R
S44_R:
    lda     #$07
    jmp     endLoop_R
endLoop_R:
    cpy     #$00
    beq     IFD1_R
    cpy     #$01
    beq     IFD2_R
    cpy     #$02
    beq     IFD3_R
    cpy     #$03
    beq     IFD4_R
    cpy     #$04
    beq     IFD5_R
    ; Should never reach here
IFD1_R:
    sta     $1ece,x
    jmp     IFD_R
IFD2_R:
    sta     $1ece+$16,x
    jmp     IFD_R
IFD3_R:
    sta     $1ece+$2c,x
    jmp     IFD_R
IFD4_R:
    sta     $1ece+$42,x
    jmp     IFD_R
IFD5_R:
    sta     $1ece+$58,x
    jmp     IFD_R

IFD_R:
    lda     $fc
    sta     $fb
    dex     
    bmi     initD_p_R
    jmp     sSRLoop_R
initD_p_R:

    dey
    bmi     initD_R
    jmp     screenShiftRight_R
initD_R:
    lda     #$02
    sta     $1efc               ; MIDDLE
    ldx     #$08
    stx     $fe

    lda     #$2a
    sta     $fb