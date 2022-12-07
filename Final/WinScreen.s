Win:
    ldx     #$50
    lda     #$02
clearGameScreen:
    sta     frameBuffer0,x
    dex
    bpl     clearGameScreen

    lda     #$04
    sta     $fe
    jsr     UpdateTileShifting

playWinMusic:
    ldx     #$30                        ; set the timer to 96 intervals of 2ms, or 192ms

    lda     #$e0                        ; C
    sta     $fb

    jsr     playNote

    lda     #$e3                        ; D
    sta     $fb

    jsr     playNote

    lda     #$e7                        ; E
    sta     $fb

    jsr     playNote

    inc     $fb                         ; F

    jsr     playNote

    lda     #$24
    sta     SCRMEM+$fb
    lda     #$07
    sta     CLRMEM+$fb

JumpWinLoop:
    jsr     load10

    lda     #$88
    sta     $fb

    jsr     charShift_V

    jsr     wait60
    jsr     load10

    jsr     characterFlip

    jsr     wait60
    jsr     load10

    lda     #$c8
    sta     $fb

    jsr     charShift_V

    jsr     wait60
    jmp     JumpWinLoop

wait60:
    lda     #$60
    sta     $fd
    jsr     timer
    rts

load10:
    lda     #$10
    sta     $fd
    sta     $fc
    rts