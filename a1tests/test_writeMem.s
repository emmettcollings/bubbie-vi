/*  
 * Stub program that immediately starts our assembly program. Will serve as the
 * entry point for our final product 
 */
    processor 6502          ; tell dasm we are writing 6502 asm

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
 */
start: 
    lda     #$21           ; this is the VIC-20 symbol for '!'
    ldx     #$51
    jsr     writeMem
    rts                     ; return to caller

/*
 * Inputs: Loc in A, data in X
 */
writeMem:
    sta     $1000,x       ; store A in $1000 + X
    rts
