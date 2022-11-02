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
    dc.b    $9e, "4142", 0  ; allocate bytes. 4125 = 101d

/* 
    Global Definitions
*/

VICCOLOR = $900F    ; Screen and border colours
SCRMEM = $1E00    ; screen memory address
CLRMEM = $9600

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Data
    _ - 0
    0 - 1
    2 - 2
    b - 3
    e - 4
    g - 5
    h - 6
    i - 7
    m - 8
    n - 9
    o - a
    r - b
    t - c
    u - d
    v - e
    y - f
*/
lC100d   .byte   $20, $30, $32, $02, $05, $07, $08, $09, $0d, $0e, $0f, $12, $14, $15, $16, $19

lC101d   .byte   $3d, $33, $74, $0c, $64, $0e, $79, $ac, $04, $9a, $d5, $60, $84, $8a, $bf, $21, $22

/*
    Main Routine
*/
start: 
    jsr     clearScreen

    lda     #$06        ; blue
    jsr     colorScreen

    lda     #$0d
    sta     $fb

    lda     #$10
    sta     $fc

    ldx     #$00
loopMain:
    lda     $101d,x
    lsr
    lsr
    lsr
    lsr
    pha
    lda     $101d,x
    and     #%00001111
    pha

    inx
    cpx     #$11
    bne     loopMain

    ldx     #$3
loopYear:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$76,x ; $31, $5b, $76
    dex
    bpl     loopYear

    ldx     #$10
loopName:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$5b,x ; $31, $5b, $76
    dex
    bpl     loopName

    ldx     #$0c
loopTitle:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$31,x ; $31, $5b, $76
    dex
    bpl     loopTitle



justinWantsInf:
    jmp    justinWantsInf   ; yeeehhhhawwwww!

/*
 * Writes whatever is in a to 512 bytes of color mem
 */
colorScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

colorLoop:      
    sta     CLRMEM,X          ; write in first half
    sta     CLRMEM+$100,X     ; write in second half
    inx
    bne     colorLoop
    rts

clearScreen:
    ldx     #$00    ; only have 1 byte that we can loop on
    lda     #$20    ; clear the screen
.loop:      
    sta     $1e00,X          ; write in first half
    sta     $1e00+$100,X     ; write in second half
    inx
    bne     .loop
    rts