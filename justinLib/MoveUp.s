initSSR_U:
    lda     #$04
    sta     $fd
screenShiftRight_U:
    lda     $fd
    cmp     #$00
    beq     IFB1_U
    cmp     #$01
    beq     IFB2_U
    cmp     #$02
    beq     IFB3_U
    cmp     #$03
    beq     IFB4_U
    cmp     #$04
    beq     IFB5_U
    ; Should never reach here

IFB1_U:
    lda     frameBuffer0+$1
    jmp     IFB_U
IFB2_U:
    lda     frameBuffer0+$2
    jmp     IFB_U
IFB3_U:
    lda     frameBuffer0+$3
    jmp     IFB_U
IFB4_U:
    lda     frameBuffer0+$4
    jmp     IFB_U
IFB5_U:
    lda     frameBuffer0+$5
    jmp     IFB_U

IFB_U:
    sta     $fb
    ldx     #$00
    ldy     #$00
sSRLoop_U:
    lda     $fd
    cmp     #$00
    beq     IFC1_U
    cmp     #$01
    beq     IFC2_U
    cmp     #$02
    beq     IFC3_U
    cmp     #$03
    beq     IFC4_U
    cmp     #$04
    beq     IFC5_U
    ; Should never reach here

IFC1_U:
    lda     frameBuffer1+$1,y
    jmp     IFC_U
IFC2_U:
    lda     frameBuffer1+$2,y
    jmp     IFC_U
IFC3_U:
    lda     frameBuffer1+$3,y
    jmp     IFC_U
IFC4_U:
    lda     frameBuffer1+$4,y
    jmp     IFC_U
IFC5_U:
    lda     frameBuffer1+$5,y
    jmp     IFC_U

IFC_U:
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
    lda     $1a00
    eor     #$06
    jmp     endLoop_U
S24_U:
    lda     $1a00
    eor     #$0b
    jmp     endLoop_U
S42_U:
    lda     $1a00
    eor     #$0a
    jmp     endLoop_U
S44_U:
    lda     $1a00
    eor     #$08
    jmp     endLoop_U

endLoop_U:
    pha
    lda     $fd
    cmp     #$00
    beq     IFD1_U
    cmp     #$01
    beq     IFD2_U
    cmp     #$02
    beq     IFD3_U
    cmp     #$03
    beq     IFD4_U
    cmp     #$04
    beq     IFD5_U
    ; Should never reach here

IFD1_U:
    pla
    sta     $1ece,x
    jmp     IFD_U
IFD2_U:
    pla
    sta     $1ece+$1,x
    jmp     IFD_U
IFD3_U:
    pla
    sta     $1ece+$2,x
    jmp     IFD_U
IFD4_U:
    pla
    sta     $1ece+$3,x
    jmp     IFD_U
IFD5_U:
    pla
    sta     $1ece+$4,x
    jmp     IFD_U
    
IFD_U:
    lda     $fc
    sta     $fb

    lda     #$16
    sta     $fe
decX_U:
    inx
    dec     $fe
    bne     decX_U

    iny
    iny
    iny
    iny
    iny
    iny
    iny

    cpy     #$1c+$1

    bpl     initD_p_U
    jmp     sSRLoop_U
initD_p_U:

    dec     $fd

    bmi     initD_U
    jmp     screenShiftRight_U

    ; iny
    ; bmi     initD_U
    ; jmp     screenShiftRight_U
initD_U:
    lda     #$02
    sta     $1efc               ; MIDDLE
    ldx     #$08
    stx     $fe

    lda     #$c8
    sta     $fb