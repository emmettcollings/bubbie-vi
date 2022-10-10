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

    ; columns: bit 0-6 set # of columns, bit 7 is apart of the video matrix
    ; rows: bits 1-6 set # of rows, bit 0 sets 8x8 or 8x16 font
    ; little endian, so its read right to left.

    ; set to 20 columns
    ; lda     #$14            ; load 00010100 (hex is 14) into accumulator
    lda     #%00010100      ; load 00010100 into accumulator
    sta     $9002           ; set # of columns on screen

    ; set to 10 rows, and 8x16 font
    ; lda     #$15            ; load 00010101 (hex is 15) into accumulator
    lda     #%00010101      ; load 00010101 into accumulator
    sta     $9003           ; set # of rows on screen

    rts                     ; return to caller