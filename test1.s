/*
    This is a comment.
*/
    processor 6502 ; This informs DASM we are assembling for the 6502 processor.

/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1101           ; Code region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

stubend:    
    dc.w    0               ; insert null byte

CHROUT = $ffd2              ; KERNAL routine we use for testing

start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHROUT          ; call CHROUT 
    rts                     ; return to caller
