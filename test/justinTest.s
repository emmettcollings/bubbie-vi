/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.
    incdir "../justinLib"
/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4434", 0  ; allocate bytes.

/* 
    Global Definitions
*/
CHROUT = $ffd2              ; kernal character output routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte


SCRMEM = $1e00                          ; Screen memory address
CLRMEM = $9600                          ; Colour memory address 
HALF = $100                             ; Half the screen size

/*
    Data
*/
    org     $1010   
    ; Blank-2
    ; Wall-3
    ; Enemy-4
    ; Chest-5    
    ; SAME:  2a
    ; COMBO: 4a+2b-2
    dc.b    $00, $3c, $26, $56, $56, $26, $3c, $24  ; AmongusL 2
    dc.b    $00, $3c, $64, $6a, $6a, $64, $3c, $24  ; AmongusR 3

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1 4
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2 5

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 6
    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall2 7

    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy1 8
    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy2 9

    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 a
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest2 b

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B c
    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall2B d

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B e
    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy1 f

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B 10
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 11

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 12
    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy1 13

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 14
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 15

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank 16
    dc.b    $00, $43, $67, $36, $18, $3c, $66, $00  ; Exit 17

    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy1 18
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 19

    dc.b    $00, $36, $7d, $7f, $7f, $3e, $1c, $08  ; HeartFull1 1a
    dc.b    $00, $36, $79, $79, $71, $3a, $1c, $08  ; HeartHalf2 1b
    dc.b    $00, $36, $49, $41, $41, $22, $14, $08  ; HeartEmpty3 1c

    dc.b    $bd, $42, $bd, $42, $bd, $42, $bd, $00  ; Border 1d

    dc.b    $00, $7c, $7e, $2a, $2a, $3e, $3e, $2a  ; Enemy 1e
    dc.b    $00, $43, $67, $36, $18, $3c, $66, $00  ; Exit 1f




frameBuffer0    .byte   $02, $02, $02, $03, $02, $03, $02, $03, $02
frameBuffer1    .byte   $03, $03, $02, $02, $03, $03, $02, $03, $02
frameBuffer2    .byte   $02, $03, $02, $02, $03, $05, $02, $03, $02
frameBuffer3    .byte   $03, $02, $04, $03, $05, $04, $02, $03, $03
frameBuffer4    .byte   $02, $04, $02, $02, $02, $03, $02, $02, $03
frameBuffer5    .byte   $03, $02, $02, $03, $03, $03, $02, $02, $03
frameBuffer6    .byte   $02, $03, $02, $02, $04, $03, $02, $03, $03
frameBuffer7    .byte   $03, $03, $04, $08, $02, $04, $02, $03, $02
frameBuffer8    .byte   $02, $02, $02, $02, $02, $03, $02, $03, $02

flagData        .byte   $00
healthData      .byte   $05

/*
    Main Routine
*/
start: 
    lda     #$fc            
    sta     $9005               ; load custom character set

    ldx     #$00                ; Initialize the counter
initializeScreen:    
    lda     #$04                ; Load a with 'space' to fill the screen with
    sta     SCRMEM,X            ; Write to the first half of the screen memory
    sta     SCRMEM+HALF,X       ; Write to the second half of the screen memory

    lda     #$00                        ; Load a with the colour of the characters to be displayed (blue)
    sta     CLRMEM,X                    ; Write to the first half of the colour memory
    sta     CLRMEM+HALF,X          ; Write to the second half of the colour memory
    inx

    bne     initializeScreen    ; Loop until the counter overflows back to 0, then exit the loop

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

INIT:
    ; LEFT: X = 3d, Y = 8a, $8d = 00
    ; RIGHT: X = 01, Y = 00, $8d = 7f
    ; UP: X = 0a, Y = 00
    ; DOWN: X = 46, Y = 8a

    ldx     #$3d
    ldy     #$8a
    lda     #$00
    sta     $8d

    jmp     MoveHorizontal
    include "Render.s"

RenderFin:
    lda     #$02
    sta     $1efc               ; MIDDLE

    lda     #$07
    sta     $fe
Loop:
    lda     #$6a
    sta     $fb
ShiftEverything:
    lda     #$10
    sta     $fd
    lda     #$c0
ShiftEverything_1:
    sta     $fc
    jsr     charShift_H
    lda     $fc
    sec
    sbc     #$10
    cmp     #$20                ; Saves time over $10 since blank doesn't need to be shifted
    bne     ShiftEverything_1

    lda     #$f0
    sta     $fc
    jsr     charShift_H

    lda     #$60
    sta     $fd
    jsr     timer
    dec     $fe 
    bpl     Loop

    lda     flagData
    eor     #%00000001
    sta     flagData
    jmp     INIT

    include "CharacterMovement.s"
    include "Timer.s"