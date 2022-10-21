/*
    Hi.
*/

/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

stubend:    
    dc.w    0               ; insert null byte

/*
    Main Program
*/
    org     $1101           ; mem location of code region
start: 
    lda     #$ac    ; funny colors 
    jsr     colorShift
    rts                     ; return to caller

/*
 * Sets the contents of the border and background color register
 * Input: border and background color bits in a
 */
colorShift:
    sta     $900f   ; location of screen and border color stuff
    rts
