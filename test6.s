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

; "PRESS ANY KEY FOR RANDOM NUMBER"
msg         .byte   $50, $52, $45, $53, $53, $20, $41, $4E, $59, $20, $4B, $45, $59, $20, $46, $4F, $52, $20, $52, $41, $4E, $44, $4F, $4D, $20, $4E, $55, $4D, $42, $45, $52, $00

    org     $1101           ; Code region
start: 
    jsr     $e55f           ; clear screen
    ldx     #$00            ; set x to 0
print:
    lda     msg,x          ; load character from message
    inx
    jsr     CHROUT          ; output character
    cmp     #$00            ; compare to null byte
    bne     print           ; if not null, print next character

nopress:
    lda     $cb
    cmp     #$40
    bne     nopress
press:
    lda     $cb
    cmp     #$40
    beq     press
    jsr     rnd_1
    and     #$07
    adc     #$30
    jsr     CHROUT
    jmp     nopress

;; Stores 1 random byte in A register
rnd_1:
    jsr     $e094
    lda     $8c
    and     $a2
    rts



    


