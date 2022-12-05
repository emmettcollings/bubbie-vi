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
    dc.b    $9e, "4725", 0  ; allocate bytes.

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
healthData      .byte   $06
healthFlag      .byte   $00
levelCount      .byte   $00

/*
    Main Routine
*/
start:
    ; lda     #$00
    ; sta     $1a01
    lda     #$0c
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

    lda     #$02    ; Red 
    sta     CLRMEM+$77
    sta     CLRMEM+$78
    sta     CLRMEM+$79

    lda     #$22    ; Hearts
    sta     SCRMEM+$77
    sta     SCRMEM+$78
    sta     SCRMEM+$79

;     ldx     #$6
;     lda     #$20    ; Timer bar
;     sta     $fb
; loadTimerBar:
;     lda     #$05
;     sta     CLRMEM+$8b,x
;     lda     $fb
;     eor     #%00000001
;     sta     $fb
;     sta     SCRMEM+$8b,x
;     dex
;     bpl     loadTimerBar

    ldx     #$08
DrawTopAndBottom:
    lda     #$06
    sta     CLRMEM+$a0,x
    sta     CLRMEM+$150,x
    lda     #$23
    sta     SCRMEM+$a0,x
    sta     SCRMEM+$150,x
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
    lda     #$23
    sta     SCRMEM+$a0,x
    sta     SCRMEM+$a8,x
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
    sta     SCRMEM+$fc               ; MIDDLE

    lda     #$ff
    sta     $fd
    jsr     timer

gameLoop:
    jsr     inputLoop
CharDoneMoving:
    jsr     loadDisplay
Damage:
    lda     #$01
    sta     healthFlag
    dec     healthData
IsOnPortal:
    lda     frameBuffer4+$4
    cmp     #$08
    bne     Health

    lda     #$08
    sta     SCRMEM
Health:
    lda     healthFlag
    beq     Health_F 
    dec     healthFlag
    lda     healthData
    cmp     #$04
    bmi     Health_2
    dec     SCRMEM+$79
    jmp     Health_F
Health_2:
    cmp     #$02
    bmi     Health_3
    dec     SCRMEM+$78
    jmp     Health_F
Health_3:
    dec     SCRMEM+$77
    lda     healthData
    cmp     #$00
    beq     GameOver
Health_F:

    lda     flagData
    eor     #%00000001
    sta     flagData
    jmp     gameLoop

    include "gameOverScreen.s"

    include "CharacterMovement.s"
    include "Render.s"
    include "Timer.s"