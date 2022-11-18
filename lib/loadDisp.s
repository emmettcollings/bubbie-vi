/*
 * Loads a 7x7 block from our encoded level data centered around where our 
 * character is and writes the full byte data to some arb mem location
 */


MAPMEM = $1000  ; Don't know where this will be yet
DISROW = $1c04  ; keep track of row we are on
BUF = $1c06    ; start of our 7x7 mem chunk
            ; IMPORTANT 1c05 MAY BE OVERWRITTEN, KEEP A GAP
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
    lda     #$07    ; initialize row counter
    sta     ROWCTR
    ldy     #$00    ; keep track of offset in our output buffer

; Load rows from map mem
.rowLoop:
    ldx     DISROW  ; load offset to data location

    ; Load first pair of tiles, need to deal with discarding one in special case
    lda     MAPMEM, X   ; load actual data
    sta     $fb         ; store in registor for SR 
    jsr     decodeByte  ; call decoding SR

; If our X pos is odd we need to discard first tile read
    lda     PX
    and     #%00000001  ; if even we save both 
    bne     .initColLoop
    lda     $fb         ; save first nibble
    sta     BUF, Y
    iny

.initColLoop:
    lda     $fc         ; second tile
    sta     BUF, Y
    inx                 ; move to next map mem byte
    iny

    lda     #$03    ; initialize column counter
    sta     COLCTR

; Decodes 6 tiles worth (3 bytes) of map data and writes to output buf
.loop:
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

; We discard last tile in this case to keep 7 total
    lda     PX
    and     #%00000001  ; if even then we discard last
    bne     .loopControl
    dey                 ; will overwrite last byte with new data next time

.loopControl:
    clc
    lda     #$10    ; 16 bytes between rows
    adc     DISROW  ; advance to next row
    sta     DISROW
    dec     ROWCTR     ; decrement our counter mem location
    bne     .rowLoop

    rts
    
