MovementDecoder:    ;fb -> tile1, a -> tile2
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

UpdateTileShifting:
    ldx     #$3d
    ldy     #$8a

    lda     #$07
    sta     $8b
UE_Init:
    lda     #$07
    sta     $8c
UE_Loop:
    lda     frameBuffer1,x
    sta     $fb

    lda     $fe
    cmp     #$00
    bne     UE_Right
    lda     frameBuffer1-$1,x
    jmp     UE_Store
UE_Right:
    cmp     #$01
    bne     UE_Down
    lda     frameBuffer1+$1,x
    jmp     UE_Store
UE_Down:
    cmp     #$02
    bne     UE_Up
    lda     frameBuffer1+$9,x
    jmp     UE_Store
UE_Up:
    cmp     #$03
    bne     UE_Null
    lda     frameBuffer1-$9,x
    jmp     UE_Store
UE_Null:
    lda     frameBuffer1+$1,x
    sta     $fb
    lda     frameBuffer1,x

UE_Store:
    jsr     MovementDecoder
    sta     SCRMEM+$b7,y

    dex
    dey

    lda     #$02
    sta     SCRMEM+$fc               ; MIDDLE

    dec     $8c
    bne     UE_Loop

    dex
    dex

    tya
    sec ;
    sbc     #$0f ;
    tay

    dec     $8b
    bne     UE_Init

    rts

    