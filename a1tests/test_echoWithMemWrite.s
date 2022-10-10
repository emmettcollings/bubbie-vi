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
    ldx     user_prompt
    jsr     printPrompt
    rts                     ; return to caller

user_prompt:
    dc.b    73,78,80,85,84,58,32,0 ; INPUT: 

/*
 * Input: loc of string in x
 */
printString:
    lda     ($00),x
    cmp     #0
    beq     done
    jsr     CHROUT
    inx
    jmp     printString

done:
    rts
    
    
