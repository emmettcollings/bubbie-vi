initSSR_L:
    ldy     #$04
screenShiftRight_L:
    cpy     #$00
    beq     IFB1_L
    cpy     #$01
    beq     IFB2_L
    cpy     #$02
    beq     IFB3_L
    cpy     #$03
    beq     IFB4_L
    cpy     #$04
    beq     IFB5_L
    ; Should never reach here
IFB1_L:
    lda     frameBuffer1
    jmp     IFB_L
IFB2_L:
    lda     frameBuffer2
    jmp     IFB_L
IFB3_L:
    lda     frameBuffer3
    jmp     IFB_L
IFB4_L:
    lda     frameBuffer4
    jmp     IFB_L
IFB5_L:
    lda     frameBuffer5
    jmp     IFB_L
IFB_L:
    sta     $fb
    ldx     #$00
sSRLoop_L:
    cpy     #$00
    beq     IFC1_L
    cpy     #$01
    beq     IFC2_L
    cpy     #$02
    beq     IFC3_L
    cpy     #$03
    beq     IFC4_L
    cpy     #$04
    beq     IFC5_L
    ; Should never reach here
IFC1_L:
    lda     frameBuffer1+$1,x
    jmp     IFC_L
IFC2_L:
    lda     frameBuffer2+$1,x
    jmp     IFC_L
IFC3_L:
    lda     frameBuffer3+$1,x
    jmp     IFC_L
IFC4_L:
    lda     frameBuffer4+$1,x
    jmp     IFC_L
IFC5_L:
    lda     frameBuffer5+$1,x
    jmp     IFC_L

IFC_L:
    sta     $fc
    cmp     #$03
    beq     S20_L
    cmp     #$04
    beq     S40_L
    ; Should never reach here
S20_L:
    lda     $fb
    cmp     #$03
    beq     S22_L
    cmp     #$04
    beq     S24_L
    ; Should never reach here
S40_L:
    lda     $fb
    cmp     #$03
    beq     S42_L
    cmp     #$04
    beq     S44_L
    ; Should never reach here

S22_L:
    lda     #$05
    jmp     endLoop_L
S24_L:
    lda     #$0a
    jmp     endLoop_L
S42_L:
    lda     #$09
    jmp     endLoop_L
S44_L:
    lda     #$07
    jmp     endLoop_L
endLoop_L:
    cpy     #$00
    beq     IFD1_L
    cpy     #$01
    beq     IFD2_L
    cpy     #$02
    beq     IFD3_L
    cpy     #$03
    beq     IFD4_L
    cpy     #$04
    beq     IFD5_L
    ; Should never reach here
IFD1_L:
    sta     $1ece,x
    jmp     IFD_L
IFD2_L:
    sta     $1ece+$16,x
    jmp     IFD_L
IFD3_L:
    sta     $1ece+$2c,x
    jmp     IFD_L
IFD4_L:
    sta     $1ece+$42,x
    jmp     IFD_L
IFD5_L:
    sta     $1ece+$58,x
    jmp     IFD_L

IFD_L:
    lda     $fc
    sta     $fb
    inx 
    cpx     #$05    
    bpl     initD_p_L
    jmp     sSRLoop_L
initD_p_L:

    dey
    bmi     initD_L
    jmp     screenShiftRight_L
initD_L:
    lda     #$02
    sta     $1efc               ; MIDDLE
    ldx     #$08
    stx     $fe

    lda     #$6a
    sta     $fb