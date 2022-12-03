MovementDecoder:
    pha

    lda     #$00
    sta     $fd

    pla
    cmp     $fb
    bne     DifferentTile
SameTile:
    asl
    rts
DifferentTile:
    cmp     $fb
    bpl     ContinueDecoding
SwapTileCodes:
    pha

    lda     #$01        ; Flag to carry on next add
    sta     $fd

    lda     $fb
    sta     $fc
    pla
    sta     $fb
    lda     $fc

ContinueDecoding:
    asl
    asl     $fb
    asl     $fb
    pha
    lda     $fd
    eor     flagData
    lsr
    pla
    adc     $fb
    sec
    sbc     #$02
    rts

MoveHorizontal:
    lda     #$07
    sta     $8b
MH_Init:
    lda     #$07
    sta     $8c
MH_Loop:
    lda     frameBuffer1,x
    sta     $fb

    cmp     $8d
    bmi     MH_Right1
MH_Left1:
    dex ;
    bcs     MH_General1 ; shortcut branch instruction
MH_Right1:
    inx
MH_General1:

    lda     frameBuffer1,x
    jsr     MovementDecoder
    sta     $1eb7,y

    cmp     $8d
    bmi     MH_Right2
MH_Left2:
    dey ;
    bcs     MH_General2 ; shortcut
MH_Right2:
    iny
MH_General2:

    dec     $8c
    bne     MH_Loop

    cmp     $8d
    bmi     MH_Right3
MH_Left3:
    dex ;
    dex ;
    tya
    sec ;
    sbc     #$0f ;
    bcs     MH_General3 ; shortcut
MH_Right3:
    inx ;
    inx ;
    tya
    clc ;
    adc     #$0f ;
MH_General3:

    tay

    dec     $8b
    bne     MH_Init
    beq     RenderFin   ; shortcut 

MoveUp:
    lda     #$07
    sta     $8b
MU_Init:
    lda     #$07
    sta     $8c
MU_Loop: