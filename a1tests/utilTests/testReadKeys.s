/*  
 * Initiates a busy loop that continues until the user presses 'Q', in which 
 * case the program exits to the OS
 */
    processor 6502          ; tell dasm we are writing 6502 asm
    incdir "../../lib"
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

CHROUT = $ffd2              ; KERNAL output char
CHRIN = $ffcf               
CLS = $e55f                 ; KERNAL clear screen

/* 
 * Our main!
 * Be careful with jsrs and jmps here, we get some funny behaviour when we try
 * to rts back to OS from a subroutine. Should come up with some convention 
 * that we follow in all such cases
 */

start: 
mainLoop:
    jmp     readInput
    jsr     busyLoop
    jmp     mainLoop    

readInput: 
    lda     $CB     ; which key
    cmp     #$30    ; 'Q' on keyboard for quit
    beq     quit
    jmp     mainLoop

quit:
    rts

    include "busyLoop.s"
