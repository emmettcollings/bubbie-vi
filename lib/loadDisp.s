/*
 * Loads a 7x7 block from our encoded level data starting at the top left 
 * corner indicated by PX and PY.
 * I assumed that it would be easier to work with camera locations to load
 * stuff and then later ensure in our logic that our character can't move in a
 * way that breaks this.
 */

MAPMEM  = $1151 ; Don't know where this will be yet
PX      = $1991 ; Storage locations of camera position
PY      = $1992
ROWCTR  = $1993 ; count rows during loop
COLCTR  = $1994 ; count columns during loop
DISROW  = $1995 ; keep track of row we are on
BUF     = $1100 ; start of our 7x7 mem chunk

    SUBROUTINE

loadDisplay:
; translate camera x/y into the compressed location first
    lda     PY      ; load y position
    asl
    asl
    asl
    asl             ; multiply by 16
    tay             ; store in y
    lda     PX      ; load x position
    lsr             ; divide by 2
    beq     next    ; if we are in first byte of row then don't have to inc
    tax
loop:
    iny             ; move to correct column in row
    dex
    bne     loop
    
; We have byte offset from base map memory location in Y now
; P nice having 32x32 map stored in 256 bytes, can use 1 byte only to index
next:
    sty     DISROW  ; store for later looping
    lda     #$09    ; initialize row counter
    sta     ROWCTR
    ldy     #$00    ; keep track of offset in our output buffer

; Load rows from map mem
.rowLoop:
    ldx     DISROW  ; load row memory location offset

    ; Load first pair of tiles, need to deal with discarding one in special case
    lda     MAPMEM,x   ; load actual data
    sta     $fb         ; store in registor for SR 
    jsr     decodeByte  ; call decoding SR

; If our X pos is odd we need to discard first tile read
    lda     PX
    and     #%00000001  ; if even we save both 
    bne     .initColLoop
    lda     $fb         ; save first tile
    sta     BUF,y
    iny

.initColLoop:
    lda     $fc         ; save second tile
    sta     BUF,y
    inx                 ; move to next map mem byte
    iny

    lda     #$04    ; initialize column counter
    sta     COLCTR

; Decodes 6 tiles worth (3 bytes) of map data and writes to output buf
.loop:
    lda     MAPMEM,x   ; load actual data
    sta     $fb         ; store in registor for SR 
    jsr     decodeByte  ; call decoding SR
    lda     $fb         ; load first tile
    sta     BUF,y      ; store in output chunk
    iny
    lda     $fc         ; second tile
    sta     BUF,y
    iny
    inx                 ; loop control stuff
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
    dec     ROWCTR     ; decrement our row counter
    bne     .rowLoop

    rts
    
