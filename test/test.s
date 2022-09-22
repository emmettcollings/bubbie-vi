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
    dc.w    1
    dc.b    $9e, "4109", 0  ; allocate bytes

stubend:    
    dc.w    0               ; insert null byte

CHROUT = $ffd2              ; KERNAL routine we use for testing

start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHROUT          ; call CHROUT 
    rts                     ; return to caller
