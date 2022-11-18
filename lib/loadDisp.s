/*
 * Loads a 7x7 block from our encoded level data centered around where our 
 * character is and writes the full byte data to some arb mem location
 */


MAPMEM = $1000  ; Don't know where this will be yet
DISROW = $1c03  ; keep track of row we are on
BUF = $1c04    ; start of our 7x7 mem chunk
PX = $1c00  ; Storage locations of camera position
PY = $1c01
CTR = $1c02 ; need one more counter to count 7 rows

/*
    Load player position
    Load 7x7 chunk around player position
    Translate chunk
    Write chunk to output location
*/

    lda     PY      ; load y position
    asl
    asl
    asl             ; multiply by 8 
    tay             ; store in y
    lda     PX      ; load x position
    lsr             ; divide by 2
    beq     next    ; if we are in first byte of row then don't have to inc
loop:
    iny             ; move to correct column
    dec
    bne     loop
    
; We have byte offset in Y
next:
    tya
    sta     DISROW  ; store for later looping
    lda     #$08    ; initialize row counter
    sta     CTR

.loop:
    jsr     loadRow

    clc
    lda     #$10
    adc     DISROW  ; advance to next row
    dec     CTR     ; decrement our counter mem location
    bne     .loop

    rts


    SUBROUTINE
/*
    Loads 8 character row from our map mem
*/
loadRow:
    ldy     #$00    ; don't really like this 0, extra bytes

.loop:
    ldx     DISROW
    lda     MAPMEM, X
    sta     $fb
    jsr     decodeByte
    lda     $fb
    sta     BUF, Y
    lda     $fc 
    sta     BUF+1, Y
    inx
    iny
    cpy     #$08
    bne     .loop

    rts

