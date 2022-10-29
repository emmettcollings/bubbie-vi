/*  
 * Draw the whole screen by drawing 23 lines. Need to think about the effects
 * our subroutines have on the xy registers, might mess things up if they get 
 * modified by called SRs
 */
    processor 6502          ; tell dasm we are writing 6502 asm
    incdir "../lib"
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

/* 
 * Our main!
 */
start: 
    jsr     initScreen
    
wait:
    nop
    jmp     wait
    ;rts                     ; return to caller

    include "initScreen.s"

