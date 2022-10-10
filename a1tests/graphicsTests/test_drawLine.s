/*  
 * Draw an entire line of the screen
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

LOC = $fd

/* 
 * Our main!
 */
start: 
    lda     #$10            ; line info
    sta     LOC
    lda     #$11            
    sta     LOC + $01

    lda     #$00            ; screen mem
    sta     SM
    lda     #$1e            
    sta     SM + $01

    jsr     drawLine
    rts                     ; return to caller

    include "globals.s"
    include "drawLine.s"

    org     $1110
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30

