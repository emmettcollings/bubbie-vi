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
    sta     TEMP1

    jsr     playNote

    lda     #$e3                        ; D
    sta     TEMP1

    jsr     playNote

    lda     #$e7                        ; E
    sta     TEMP1

    jsr     playNote

    inc     TEMP1                       ; F

    jsr     playNote

    lda     #$24
    sta     SCRMEM+TEMP1
    lda     #$07
    sta     CLRMEM+TEMP1

JumpWinLoop:
    jsr     load10

    lda     #$88
    sta     TEMP1

    jsr     charShift_V

    jsr     wait60
    jsr     load10

    jsr     characterFlip

    jsr     wait60
    jsr     load10

    lda     #$c8
    sta     TEMP1

    jsr     charShift_V

    jsr     wait60
    jmp     JumpWinLoop

wait60:
    lda     #$70
    sta     $fd
    jsr     timer
    rts

load10:
    lda     #$10
    sta     $fd
    sta     TEMP2
    rts