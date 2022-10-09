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
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    ; clear screen
    lda     #$93            ; clear screen code
    jsr     $ffd2           ; write character to screen

    ; moves cursor down 12 lines
    lda     #$0c            ; load 12 into accumulator
    sta     $00d3           ; shifts the character output to the right by 12 columns (aka this mem location moves left/right)
    ; todo: figure out how to move cursor down 12 lines before printing text
    sta     $00d6           ; shifts the cursor down by 12 lines (aka this mem location moves down only for some reason... but it does it after the character is output)

    ; write the character 'R' to the center of the screen
    lda     #$52            ; load accumulator with 'R'
    jsr     $ffd2           ; write character to screen

    rts                     ; return to caller