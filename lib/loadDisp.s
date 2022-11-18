/*
 * Loads a 7x7 block from our encoded level data centered around where our 
 * character is and writes the full byte data to some arb mem location
 */


MAPMEM = $1000  ; Don't know where this will be yet
DISROW = $1c04  ; keep track of row we are on
BUF = $1c05    ; start of our 7x7 mem chunk
PX = $1c00  ; Storage locations of camera position
PY = $1c01
ROWCTR = $1c02 ; need one more counter to count 7 rows
COLCTR = $1c03
/*
    Load camera position
    Load 8 tiles and translate
    Shift so we keep only correct 7 tiles
    Repeat for 7 rows
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
    sta     ROWCTR

; Load rows from map mem
.rowLoop:
    lda     #$08
    sta     COLCTR
    ldy     #$00    ; keep track of offset in our output buffer

.loop:
    ldx     DISROW  ; load offset to data location
    lda     MAPMEM, X   ; load actual data
    sta     $fb         ; store in registor for SR 
    jsr     decodeByte  ; call decoding SR
    lda     $fb         ; load first tile
    sta     BUF, Y      ; store in output chunk
    lda     $fc         ; second tile
    sta     BUF+1, Y
    inx                 ; loop control stuff
    iny
    dec     COLCTR
    bne     .loop

    ; check which way we shift to keep only 7 tiles
    lda     PX
    and     #%00000001  ; if odd then we shift left

    clc
    lda     #$10
    adc     DISROW  ; advance to next row
    dec     ROWCTR     ; decrement our counter mem location
    bne     .rowLoop

    rts
    
