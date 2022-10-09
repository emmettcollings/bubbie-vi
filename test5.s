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
    Main Routine
*/
start: 
    ; clear screen
    lda     #$93            ; clear screen code
    jsr     $ffd2           ; write character to screen

    ; moves cursor down 15 lines
    lda     #$0f            ; load 15 into accumulator
    sta     $00d6           ; sets where the cursor is on the screen

    ; columns: bit 0-6 set # of columns, bit 7 is apart of the video matrix
    ; rows: bits 1-6 set # of rows, bit 0 sets 8x8 or 8x16 font
    ; set to 20 columns
    lda     #$50            ; load 01010000 into accumulator
    sta     $9002           ; set # of columns on screen

    ; set to 10 rows, and 8x16 font
    lda     #$92            ; load 10010010 into accumulator
    sta     $9003           ; set # of rows on screen

    lda     #$05
    sta     $00d1
    sta     $00d2

    ; write the character 'R' to the center of the screen
    lda     #$52            ; load accumulator with 'R'
    jsr     $ffd2           ; write character to screen

    rts                     ; return to caller