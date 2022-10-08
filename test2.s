/*
    This is a comment.
*/
    processor 6502 ; This informs DASM we are assembling for the 6502 processor.

/*
    Thanks to Emmett for the following code, as I needed some test code to ensure everything was working!
 */

/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

stubend:    
    dc.w    0               ; insert null byte

CHROUT = $ffd2              ; KERNAL routine we use for testing

; Print the alphabet by looping through the characters
start: 
    ldx     #$41
loop:
    txa
    jsr     CHROUT
    inx
    cpx     #$5b
    bne     loop
    rts

    


