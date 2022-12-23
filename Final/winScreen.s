Win:
    ldx     #$50
    lda     #$02
clearGameScreen:
    sta     frameBuffer0,x
    dex
    bpl     clearGameScreen

    lda     #$04
    sta     TEMP4
    jsr     UpdateTileShifting

playWinMusic:
    ldx     #$30                        ; set the timer to 96 intervals of 2ms, or 192ms

    ; win music (not the best, but it works)
    lda     #$87                        ; C
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$97                        ; D#
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$87                        ; C
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$97                        ; D#
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$a3                        ; F
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$a7                        ; F#
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$a3                        ; F
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$a7                        ; F#
    sta     OSC2
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC2
    
    lda     #$87                        ; C 
    sta     OSC3
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$97                        ; D#
    sta     OSC3
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$87                        ; C 
    sta     OSC3
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$97                        ; D#
    sta     OSC3
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$a7                        ; F#
    sta     OSC3
    ldx     #$7f
    stx     $1001                       ; store our timer value
    jsr     timer

    lda     #$00                        ; Reset
    sta     OSC3
    ; end win music

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
    sta     TEMP3
    jsr     timer
    rts

load10:
    lda     #$10
    sta     TEMP3
    sta     TEMP2
    rts
