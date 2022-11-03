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
    dc.b    $9e, "4109", 0  ; allocate bytes.

/* 
    Global Definitions
*/

VICCOLOR = $900F    ; Screen and border colours
SCRMEM = $1E00    ; screen memory address
CLRMEM = $9600

DATASTART = $1101

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Main Routine
*/
start: 
    jsr     clearScreen

    lda     #$06        ; blue
    jsr     colorScreen

    ldy     #$00
    sty     $fc
L2:
    lda     $DATASTART+$1,y
    cmp     #$00
justinWantsInf:
    beq     justinWantsInf   ; yeeehhhhawwwww!
    tax
    lda     $DATASTART,y
    iny
    iny
    sty     $fb
    ldy     $fc
L1:
    sta     $1e00,y
    iny
    dex
    bne     L1
    sty     $fc
    ldy     $fb
    jmp     L2

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

/*
    Data
    _ - 20
    0 - 30
    2 - 32
    b - 02
    e - 05
    g - 07
    h - 08
    i - 09
    m - 0d
    n - 0e
    o - 0f
    r - 12
    t - 14
    u - 15
    v - 16
    y - 19
*/

    org     $1101

    dc.b    $20, $31, $02, $01, $15, $01, $02, $02, $09, $01, $05, $01, $20, $01    ; BUBBIE
    dc.b    $14, $01, $08, $01, $05, $01, $20, $01                                  ; THE
    dc.b    $16, $01, $09, $01, $20, $1d                                            ; VI

    dc.b    $0e, $01, $0f, $01, $14, $01, $20, $01                                  ; NOT
    dc.b    $05, $01, $0e, $01, $0f, $01, $15, $01, $07, $01, $08, $01, $20, $01    ; ENOUGH
    dc.b    $0d, $01, $05, $01, $0d, $01, $0f, $01, $12, $01, $19, $01, $20, $0a    ; MEMORY

    dc.b    $32, $01, $30, $01, $32, $02, $ff, $00                                   ; 2022

