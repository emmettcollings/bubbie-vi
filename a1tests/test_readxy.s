/*  
 * Read in x and y coordinates from user, then set the position of the cursor 
 * to those coordinates
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

/*
 * KERNAL routines we need for this subroutine
 */
CHROUT = $ffd2              ; KERNAL output char
CHRIN = $ffcf               
CLS = $e55f                 ; KERNAL clear screen

/* 
 * Our main!
 */
start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHRIN
    jsr     CHROUT
    rts                     ; return to caller

readxy:
    lda
