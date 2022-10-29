/*  
 * Subroutine that takes offset in y and prints out string
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

LOC = $fb                   ; set up indirect addr in free zero page space
CHROUT = $ffd2

/* 
 * Our main!
 */
start: 
    lda     #$00            ; set low order index
    sta     LOC
    lda     #$11            ; set high order index
    sta     LOC + $01

    ldy     #$00
    jsr     printString
    rts                     ; return to caller

/*
 * Input: loc of string in y
 */
printString:
    lda     (LOC),y         ; load string start location
    cmp     #0
    beq     done
    jsr     CHROUT
    iny
    jmp     printString

done:
    rts

    org     $1100
    dc.b    72,69,76,76,79,0 ; HELLO


