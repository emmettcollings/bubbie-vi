/*
 * Input: offset in y
 */
drawLine:
    ldy     #$00     

.loop:
    lda     #$1110,y        ; load byte
    sta     (SM),y          ; store byte in screen mem
    iny                     ; increment y
    cpy     #$16
    beq     .done
    jmp     .loop

.done:
    rts


