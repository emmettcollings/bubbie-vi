/*
    Title Screen Test

    This test will display the title screen to the user.
    Current TODO List:
        - Figure out a good way to horizontally center the text. (We know how to shift left/right, just want to "automate" it if possible, otherwise we can hardcode it easily.)
        - Figure out how to center it vertically. (No clue how to shift up/down yet...)
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
CLS = $e55f                 ; kernal clear screen routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Data
*/
l100d   .byte   $42, $55, $42, $42, $49, $45, $20, $54, $48, $45, $20, $56, $49 ; Bubbie the VI (Length: 13)
l100e   .byte   $4e, $4f, $54, $20, $45, $4e, $4f, $55, $47, $48, $20, $4d, $45, $4d, $4f, $52, $59 ; Not Enough Memory (Length: 17)
l100f   .byte   $32, $30, $32, $32 ; 2022 (Length: 4)

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    jsr     CLS             ; clear screen

    ldx     #$00            ; set x register to 0
    jsr     printGameName   ; print game name

    jsr     resetOutput     ; reset output before next line

    ldx     #$00            ; set x register to 0
    jsr     printTeamName   ; print team name

    jsr     resetOutput     ; reset output before next line

    lda     #$0a            ; set a register to 10
    jsr     shiftHorizontally ; shift horizontally 10 spaces
    ldx     #$00            ; set x register to 0
    jsr     printYear       ; print year

    rts                     ; return to caller

resetOutput:
    lda     #$11            ; load new line character
    jsr     CHROUT          ; print a newline
    lda     #$00            ; load 0 to reset column shift
    sta     $00d3           ; set column shift to 0
    rts

shiftVertically:
    ; todo: figure out how to shift up/down
    rts

shiftHorizontally:
    sta     $00d3           ; set column shift to 1
    rts

printGameName:
    lda     l100d,x         ; load byte from game name string
    jsr     CHROUT          ; output the byte
    inx                     ; increment x register
    cpx     #$0d            ; compare x register to the length of the game name string (find a way to automate this if possible?)
    bne     printGameName   ; if not equal, jump back to the top of the routine
    rts                     ; return to caller

printTeamName:
    lda     l100e,x         ; load a byte from the team name string
    jsr     CHROUT          ; output the byte
    inx                     ; increment x register
    cpx     #$11            ; compare x register to the length of the team name string (find a way to automate this if possible?)
    bne     printTeamName   ; if not equal, jump back to the top of the routine
    rts                     ; return to caller

printYear:
    lda     l100f,x         ; load a byte from the year string
    jsr     CHROUT          ; output the byte
    inx                     ; increment x register
    cpx     #$04            ; compare x register to the length of the year string (find a way to automate this if possible?)
    bne     printYear       ; if not equal, jump back to the top of the routine
    rts                     ; return to caller