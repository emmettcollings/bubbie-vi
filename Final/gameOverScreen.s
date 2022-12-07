GameOver:
    jsr     timer
    dec     $fd
    jsr     timer
    lda     #$02
    sta     CLRMEM+$fc               ; MIDDLE
    asl
    sta     $8e
    asl
    sta     $8c
    dec     $fd
    jsr     timer
    dec     $fd
    jsr     timer
FlailLoopSink:
    dec     $8e
    bne     FlailLoopFlip
    lda     #$04
    sta     $8e
    lda     #$c8
    sta     $fb
    lda     #$10
    sta     $fd
    sta     $fc
    jsr     charShift_V
    dec     $8c
    beq     EndGameState
FlailLoopFlip:
    lda     #$60
    sta     $fd
    jsr     timer

    lda     #$10
    sta     $fd
    sta     $fc
    jsr     characterFlip
    jmp     FlailLoopSink
EndGameState:
    jmp     EndGameState