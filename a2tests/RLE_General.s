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
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = 100d

/* 
    Global Definitions
*/

VICCOLOR = $900f    ; Screen and border colours
SCRMEM = $1e00    ; screen memory address
CLRMEM = $9600
HALF_SIZE = $0100

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
    sty     $fd
mainLoop:
    lda     DATASTART+$01,y
    cmp     #$00
infLoop:
    beq     infLoop   ; yeeehhhhawwwww!
    tax
    lda     DATASTART,y
    iny
    iny
    sty     $fb
    ldy     $fc
writeToScreenLoop:
    pha
    lda     $fd
    cmp     #$00
    bne     writeToHighScreen
    pla
    sta     SCRMEM,y
    jmp     writeToLowScreen
writeToHighScreen:
    pla
    sta     SCRMEM+HALF_SIZE,y
writeToLowScreen:
    iny
    bne     swapScreenLowHigh
    inc     $fd
swapScreenLowHigh:
    dex
    bne     writeToScreenLoop
    sty     $fc
    ldy     $fb
    jmp     mainLoop

/*
 * Writes whatever is in a to 512 bytes of color mem
 */
colorScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

colorLoop:      
    sta     CLRMEM,X          ; write in first half
    sta     CLRMEM+HALF_SIZE,X     ; write in second half
    inx
    bne     colorLoop
    rts


clearScreen:
    ldx     #$00    ; only have 1 byte that we can loop on
    lda     #$20    ; clear the screen
.loop:      
    sta     SCRMEM,X          ; write in first half
    sta     SCRMEM+HALF_SIZE,X     ; write in second half
    inx
    bne     .loop
    rts

    org     $1101

    dc.b    $20, $31, $02, $01, $15, $01, $02, $02, $09, $01, $05, $01, $20, $01    ; BUBBIE
    dc.b    $14, $01, $08, $01, $05, $01, $20, $01                                  ; THE
    dc.b    $16, $01, $09, $01, $20, $1d                                            ; VI

    dc.b    $0e, $01, $0f, $01, $14, $01, $20, $01                                  ; NOT
    dc.b    $05, $01, $0e, $01, $0f, $01, $15, $01, $07, $01, $08, $01, $20, $01    ; ENOUGH
    dc.b    $0d, $01, $05, $01, $0d, $01, $0f, $01, $12, $01, $19, $01, $20, $0a    ; MEMORY

    dc.b    $32, $01, $30, $01, $32, $02, $ff, $00                                  ; 2022

