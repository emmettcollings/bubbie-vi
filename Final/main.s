/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.
    incdir "../justinLib"
    incdir      "../lib"
/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4691", 0  ; allocate bytes.

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/* 
    Global Definitions
*/
CHROUT = $ffd2                          ; kernal character output routine
SCRMEM = $1e00                          ; Screen memory address
CLRMEM = $9600                          ; Colour memory address 
HALF = $100                             ; Half the screen size

    include "chars.s"
    include "mapData.s"

flagData        .byte   $00
healthData      .byte   $05

/*
    Main Routine
*/
start:
    ; lda     #$00
    ; sta     $1a01
    lda     #$0d
    sta     PX
    lda     #$05
    sta     PY

    jsr     loadDisplay

    ; Initialize x to 0, and then jump to initiializeTitleScreen subroutine (titleScreen.s)
    ldx     #$00                    ; Initialize the counter
    jmp     initiializeTitleScreen

    include "Decoder.s"
    include "loadDisp.s"
    include "titleScreen.s"               ; include the main program file
    include "inputBuffer.s"

gameInit:
    ldx     #$00                ; Initialize the counter
    lda     #$fc            
    sta     $9005               ; load custom character set
    lda     #$04                ; Load a with 'space' to fill the screen with
clearScreen:    
    sta     SCRMEM,X            ; Write to the first half of the screen memory
    sta     SCRMEM+HALF,X       ; Write to the second half of the screen memory
    inx
    bne     clearScreen    ; Loop until the counter overflows back to 0, then exit the loop
clearScreenColour:
    lda     #$00
    sta     CLRMEM,X                    ; Write to the first half of the colour memory
    sta     CLRMEM+HALF,X          ; Write to the second half of the colour memory
    inx
    bne     clearScreenColour    ; Loop until the counter overflows back to 0, then exit the loop

    lda     #$02
    sta     CLRMEM+$77
    sta     CLRMEM+$78
    sta     CLRMEM+$79

    lda     #$1a
    sta     $1e77
    lda     #$1a
    sta     $1e78
    lda     #$1a
    sta     $1e79

    ldx     #$08
DrawTopAndBottom:
    lda     #$06
    sta     CLRMEM+$a0,x
    sta     CLRMEM+$150,x
    lda     #$1d
    sta     $1ea0,x
    sta     $1f50,x
    dex
    bpl     DrawTopAndBottom

    ldx     #$9a
    tay
    sec
DrawSides:
    tya
    lda     #$06
    sta     CLRMEM+$a0,x
    sta     CLRMEM+$a8,x
    lda     #$1d
    sta     $1ea0,x
    sta     $1ea8,x
    txa
    sbc     #$16
    tax
    bne     DrawSides

    ; LEFT: X = 3d, Y = 8a, $8d = 00
    ; RIGHT: X = 01, Y = 00, $8d = 7f
    ; UP: X = 0a, Y = 00
    ; DOWN: X = 46, Y = 8a

    ldx     #$0a
    ldy     #$00

    jsr     MoveUp
    lda     #$02
    sta     $1efc               ; MIDDLE

    lda     #$ff
    sta     $fd
    jsr     timer

gameLoop:
    jsr     inputLoop
CharDoneMoving:

Damage:


    lda     flagData
    eor     #%00000001
    sta     flagData
    jmp     gameLoop

    include "displayHealth.s"

    include "CharacterMovement.s"
    include "Render.s"
    include "Timer.s"