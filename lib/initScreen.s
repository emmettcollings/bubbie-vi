/*
 * Sets up the screen the way we want it. For now just turns background black,
 * fills screen with a character and sets the char colors to green
 */

CLRREG = $900F    ; Screen and border colours
SCRMEM = $1E00    ; screen memory address
CLRMEM = $9600
size   = $100     ; 256 byte offset so that we write both halves of mem chunk
                  ; in one loop iteration

    SUBROUTINE

initScreen:
    lda     #$08        ; Define screen colour and background (black)
    sta     CLRREG

    lda     #$2a        ; going with dots for now
    jsr     clearScreen

    lda     #$05        ; green
    jsr     colorScreen

    rts

    SUBROUTINE

/*
 * Writes whatever is in a to 512 bytes of screen mem
 */
clearScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

.loop:      
    sta     SCRMEM,X          ; write in first half
    sta     SCRMEM+size,X     ; write in second half
    inx
    bne     .loop
    rts

    SUBROUTINE
/*
 * Writes whatever is in a to 512 bytes of color mem
 */
colorScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

.loop:      
    sta     CLRMEM,X          ; write in first half
    sta     CLRMEM+size,X     ; write in second half
    inx
    bne     .loop
    rts

