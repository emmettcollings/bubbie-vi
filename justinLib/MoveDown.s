initSSR_D:
    lda     #$04
    sta     $fd
screenShiftRight_D:
    lda     $fd
    cmp     #$00
    beq     IFB1_D
    cmp     #$01
    beq     IFB2_D
    cmp     #$02
    beq     IFB3_D
    cmp     #$03
    beq     IFB4_D
    cmp     #$04
    beq     IFB5_D
    ; Should never reach here

IFB1_D:
    lda     frameBuffer6+$1
    jmp     IFB_D
IFB2_D:
    lda     frameBuffer6+$2
    jmp     IFB_D
IFB3_D:
    lda     frameBuffer6+$3
    jmp     IFB_D
IFB4_D:
    lda     frameBuffer6+$4
    jmp     IFB_D
IFB5_D:
    lda     frameBuffer6+$5
    jmp     IFB_D

IFB_D:
    sta     $fb
    ldx     #$58
    ldy     #$1c
sSRLoop_D:
    lda     $fd
    cmp     #$00
    beq     IFC1_D
    cmp     #$01
    beq     IFC2_D
    cmp     #$02
    beq     IFC3_D
    cmp     #$03
    beq     IFC4_D
    cmp     #$04
    beq     IFC5_D
    ; Should never reach here

IFC1_D:
    lda     frameBuffer1+$1,y
    jmp     IFC_D
IFC2_D:
    lda     frameBuffer1+$2,y
    jmp     IFC_D
IFC3_D:
    lda     frameBuffer1+$3,y
    jmp     IFC_D
IFC4_D:
    lda     frameBuffer1+$4,y
    jmp     IFC_D
IFC5_D:
    lda     frameBuffer1+$5,y
    jmp     IFC_D

IFC_D:
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
    lda     $1a00
    eor     #$06
    jmp     endLoop_D
S24_D:
    lda     $1a00
    eor     #$0b
    jmp     endLoop_D
S42_D:
    lda     $1a00
    eor     #$0a
    jmp     endLoop_D
S44_D:
    lda     $1a00
    eor     #$08
    jmp     endLoop_D

endLoop_D:
    pha
    lda     $fd
    cmp     #$00
    beq     IFD1_D
    cmp     #$01
    beq     IFD2_D
    cmp     #$02
    beq     IFD3_D
    cmp     #$03
    beq     IFD4_D
    cmp     #$04
    beq     IFD5_D
    ; Should never reach here

IFD1_D:
    pla
    sta     $1ece,x
    jmp     IFD_D
IFD2_D:
    pla
    sta     $1ece+$1,x
    jmp     IFD_D
IFD3_D:
    pla
    sta     $1ece+$2,x
    jmp     IFD_D
IFD4_D:
    pla
    sta     $1ece+$3,x
    jmp     IFD_D
IFD5_D:
    pla
    sta     $1ece+$4,x
    jmp     IFD_D
    
IFD_D:
    lda     $fc
    sta     $fb

    lda     #$16
    sta     $fe
decX_D:
    dex
    dec     $fe
    bne     decX_D

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

    dec     $fd

    bmi     initD_D
    jmp     screenShiftRight_D

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