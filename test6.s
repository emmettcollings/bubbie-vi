/*
    TEST INFORMATION GOES HERE!
*/

/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

/* 
    Global Definitions
*/
CHROUT = $ffd2              ; kernal character output routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Data
*/
; "PRESS ANY KEY FOR RANDOM NUMBER"
msg         .byte   $50, $52, $45, $53, $53, $20, $41, $4E, $59, $20, $4B, $45, $59, $20, $46, $4F, $52, $20, $52, $41, $4E, $44, $4F, $4D, $20, $4E, $55, $4D, $42, $45, $52, $00

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
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

; Stores 1 random byte in A register
rnd_1:
    jsr     $e094
    lda     $8c
    eor     $a2
    rts