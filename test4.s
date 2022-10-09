/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/* 
    Background Color Change Routine
*/
bgColor:
    ; bits 0-2 = screen background, bit 3 = inverted or normal, bits 4-7 = background color
    lda     #$08            ; load accumulator with $08 (leads to black background, blue text)
    sta     $900f           ; set background color
    jmp     bgColor         ; loop forever

/*
    Main Routine
*/
start: 
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     $ffd2           ; call CHROUT (The KERNAL routine for printing a character)
    jsr     bgColor         ; call bgColor subroutine
    rts                     ; return to caller