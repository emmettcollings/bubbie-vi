/*
    Title Screen Test

    This test will display the title screen to the user.
    Current TODO List:
        - Figure out what's wrong with the math for the vertical centering of the title (It's not correct)
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

    ldx     #$04            ; set x to 4
    jsr     shiftVerticalA  ; shift text down 4 lines

    ldx     #$0d            ; load x with length of string 
    jsr     shiftHorizontalA ; shift horizontally to center text
    ldx     #$00            ; set x register to 0
    jsr     printGameName   ; print game name

    jsr     resetOutput     ; reset output before next line
    jsr     printNewLine    ; print new line

    ldx     #$11            ; load x with length of string
    jsr     shiftHorizontalA ; shift horizontally to center text
    ldx     #$00            ; set x register to 0
    jsr     printTeamName   ; print team name

    jsr     resetOutput     ; reset output before next line

    ldx     #$04            ; load x with length of string
    jsr     shiftHorizontalA ; shift horizontally to center text
    ldx     #$00            ; set x register to 0
    jsr     printYear       ; print year

justinWantsInf:
    jmp    justinWantsInf   ; yeeehhhhawwwww!

resetOutput:
    lda     #$11            ; load new line character
    jsr     CHROUT          ; print a newline
    lda     #$00            ; load 0 to reset column shift
    sta     $00d3           ; set column shift to 0
    rts                     ; return to caller

shiftVerticalM:
    jsr     printNewLine    ; print new line
    dex                     ; decrement x
    cpx     #$00            ; compare x to 0
    bne     shiftVerticalM  ; if x is not 0, branch to shiftVertically
    rts                     ; return to caller

shiftVerticalA: ; todo: figure out why this isn't working as expected. (only shifting down like 2 lines when given 4. should shift down 11 - 2 = 9 lines)
    lda     #$0b            ; floor(22/2), aka half the screen height
    stx     $1099           ; arbitrary storage location
    lsr     $1099           ; divide by 2
    sbc     $1099           ; subtract a from x
    ldx     $1099           ; set x to value in $1099
    jsr     shiftVerticalM  ; jump to shiftVerticalM, which will shift down x lines
    rts                     ; return to caller

shiftHorizontalA: ; shift horizontally by a number of spaces automatically (aka, user provides the length of the string)
    lda     #$0b            ; floor(23/2), aka roughly half the screen width
    stx     $1099           ; arbitrary storage location
    lsr     $1099           ; divide by 2
    sbc     $1099           ; subtract a from x
    sta     $00d3           ; store column shift
    rts                     ; return to caller

shiftHorizontalM: ; shift horizontally by a number of spaces manually (aka, user provides the number of spaces to shift)
    stx     $00d3           ; set column shift to x register
    rts                     ; return to caller
    
printNewLine:
    lda     #$11            ; load new line character
    jsr     CHROUT          ; print a newline
    rts                     ; return to caller

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