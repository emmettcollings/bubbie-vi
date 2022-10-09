/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1101           ; Code region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Main Routine
*/
start: 
    ; clear screen
    lda     #$93            ; clear screen code
    jsr     $ffd2           ; write character to screen

    ; moves cursor down 15 lines
    lda     #$0f            ; load 15 into accumulator
    sta     $00d6           ; sets where the cursor is on the screen

    ; write the character 'R' to the center of the screen
    lda     #$52            ; load accumulator with 'R'
    jsr     $ffd2           ; write character to screen

    rts                     ; return to caller