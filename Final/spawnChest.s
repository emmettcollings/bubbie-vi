chestLocs   .byte   $42, $4e, $e8, $f2
portalLocs   .byte   $5d, $9f, $b2, $c8
chestReplacement_N .byte   $52, $35, $53, $52
portalReplacement_N .byte   $82, $28, $82, $83
chestReplacement_O .byte   $22, $32, $23, $22
portalReplacement_O .byte   $22, $22, $22, $23

spawnChestAndPortal:
    jsr     somethingRandom
    jsr     somethingRandom

    lda     randomData
    and     #%00000011
    tay

    lda     chestLocs,y
    tax

    lda     chestReplacement_N,y

    sta     Map1,x

    jsr     somethingRandom
    jsr     somethingRandom

    lda     randomData
    and     #%00000011
    tay

    lda     portalLocs,y
    tax

    lda     portalReplacement_N,y

    sta     Map1,x

    rts

despawnChestAndPortal:
    ldy     #$03
despawnChestLoop:
    lda     chestLocs,y
    tax

    lda     chestReplacement_O,y

    sta     Map1,x
    dey
    bpl     despawnChestLoop
    ldy     #$03
despawnPortalLoop:
    lda     portalLocs,y
    tax

    lda     portalReplacement_O,y

    sta     Map1,x
    dey
    bpl     despawnPortalLoop
    rts
