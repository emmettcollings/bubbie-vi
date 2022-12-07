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
    dc.b    $9e, "4740", 0  ; allocate bytes.

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

; Sound registers
OSC1 = $900a                            ; The first oscillator.
OSC2 = $900b                            ; The second oscillator.
OSC3 = $900c                            ; The third oscillator.
OSCNS = $900d                           ; The noise source oscillator.
OSCVOL = $900e                          ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)


    include "chars.s"
    include "mapData.s"

randomData      .byte   $00
flagData        .byte   $00
healthData      .byte   $0e
healthFlag      .byte   $00
duckData        .byte   $00
duckFlag        .byte   $00

PX              .byte   $00
PY              .byte   $00
ROWCTR          .byte   $00
COLCTR          .byte   $00
DISROW          .byte   $00


/*
    Main Routine
*/
start:
    lda     #$01                        ; set the volume of the oscillators to 1
    sta     OSCVOL

    lda     #$18
    sta     $900f
    ; lda     #$00
    ; sta     $1a01
    lda     #$0c
    sta     PX
    lda     #$05
    sta     PY

    jsr     spawnChestAndPortal
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
    jsr     drawHearts
    jmp     loadDuckBar

drawHearts:
    ldx     #$06
drawHeartsLoop:
    lda     #$02    ; Red 
    sta     CLRMEM+$75,x

    lda     #$22    ; Hearts
    sta     SCRMEM+$75,x
    dex
    bpl     drawHeartsLoop
    rts


loadDuckBar:
    ldx     #$07
loadDuckBarLoop:
    txa
    sta     CLRMEM+$6,x
    dex
    cpx     #$01
    bne     loadDuckBarLoop

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

    lda     #$00
    sta     $fe
    jsr     UpdateTileShifting
    lda     #$02
    sta     SCRMEM+$fc               ; MIDDLE

    lda     #$ff
    sta     $fd
    jsr     timer

gameLoop:
    jsr     inputLoop
CharDoneMoving:
    jsr     loadDisplay
ProcessEnemies_M:
    lda     #$30
    sta     $fd
    sta     $fe
    jsr     timer
    jsr     processEnemies

    lda     #$04
    sta     $fe
    jsr     UpdateTileShifting

DamageCalc:
    lda     frameBuffer3+$04
    cmp     #$04
    beq     TakeDamage

    lda     frameBuffer5+$04
    cmp     #$04
    beq     TakeDamage

    lda     frameBuffer4+$03
    cmp     #$04
    beq     TakeDamage

    lda     frameBuffer4+$05
    cmp     #$04
    beq     TakeDamage
    jmp     IsOnPortal
TakeDamage:



    lda     #$01
    sta     healthFlag
    dec     healthData
IsOnPortal:
    lda     frameBuffer4+$4
    cmp     #$08
    bne     Health

    jsr     despawnChestAndPortal
    jsr     spawnChestAndPortal

    jsr     drawHearts          ; refill health
    lda     #$0e
    sta     healthData

    lda     duckData
    cmp     #$07
    bne     GameDoesntEnd
    jmp     Win
GameDoesntEnd:
    lda     #$00
    sta     duckFlag
    jsr     loadDisplay
    lda     #$04
    sta     $fe
    jsr     UpdateTileShifting
Health:
    lda     healthFlag
    beq     Duck 
    dec     healthFlag
    lda     healthData
    cmp     #$0c
    bmi     Health_1
    dec     SCRMEM+$7b
    jmp     Duck
Health_1:
    cmp     #$0a
    bmi     Health_2
    dec     SCRMEM+$7a
    jmp     Duck
Health_2:
    cmp     #$08
    bmi     Health_3
    dec     SCRMEM+$79
    jmp     Duck
Health_3:
    cmp     #$06
    bmi     Health_4
    dec     SCRMEM+$78
    jmp     Duck
Health_4:
    cmp     #$04
    bmi     Health_5
    dec     SCRMEM+$77
    jmp     Duck
Health_5:
    cmp     #$02
    bmi     Health_6
    dec     SCRMEM+$76
    jmp     Duck
Health_6:
    dec     SCRMEM+$75
    lda     healthData
    cmp     #$00
    bne     Duck
    jmp     GameOver
Duck:
    lda     duckFlag
    beq     Tick
    lda     #$24
    ldx     duckData
    sta     SCRMEM+$06,x
SpawnEnemies:
    jsr     somethingRandom     ; flip coin to decide whether to move randomly
    lda     randomData

    and     #%00001111
    bne     Tick

    lda     #$04
    sta     frameBuffer0+$04


Tick:

    lda     flagData
    eor     #%00000001
    sta     flagData
    jmp     gameLoop

    include "enemy.s"
    include "CharacterMovement.s"
    include "Render.s"
    include "Timer.s"

    include "gameOverScreen.s"
    include "WinScreen.s"

    include "music.s"
    include "spawnChest.s"