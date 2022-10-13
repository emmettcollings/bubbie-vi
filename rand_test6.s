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

    ; moves cursor down 15 lines
    lda     #$0f            ; load 15 into accumulator
    sta     $00d6           ; sets where the cursor is on the screen

    ; write the character 'R' to the center of the screen
    lda     #$52            ; load accumulator with 'R'
    jsr     $ffd2           ; write character to screen

    jsr     disableCursor   ; call disableCursor routine

    rts                     ; return to caller

/* 
    Disable Cursor (Flash) Routine
*/
disableCursor:
    ; 0 = flash, 1 = steady
    lda     #$01            ; load accumulator with $00
    sta     $00cc           ; store accumulator in $00cc
    jmp disableCursor