/*
    This is a comment.
*/
    processor 6502 ; This informs DASM we are assembling for the 6502 processor.

/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

stubend:    
    dc.w    0               ; insert null byte

CHROUT  =   $FFD2           ; KERNEL | Output character to channel

pad         .byte   $00, $00, $00   ; Padding so that next byte is on 8 byte boundary

chr_1       .byte   $00, $3c, $26, $56, $56, $26, $3c, $24  ; sus?

    org     $1101           ; Code region
start: 
    lda     #$fc            
    sta     $9005           ; load custom character set
    jsr     $e55f           ; clear screen
    lda     #$42            ; set x to first character in new character set
    jsr     CHROUT
loop:
    jmp     loop

