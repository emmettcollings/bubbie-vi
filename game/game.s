/*
    Data
*/
    org     $1010
    dc.b    $00, $3c, $26, $56, $56, $26, $3c, $24  ; Amongus 2
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank 3
    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall 4
    dc.b    $aa, $00, $aa, $00, $aa, $00, $aa, $00  ; Border 5

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1 6
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2 7

    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall1 8
    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall2 9

    dc.b    $FF, $BD, $BD, $FF, $FF, $BD, $BD, $FF  ; Wall1B 10
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2B 11

startRender: 
    lda     #$fc            
    sta     $9005               ; load custom character set

    ldx     #$00                ; Initialize the counter
initializeScreen:    
    lda     #$03                ; Load a with 'space' to fill the screen with
    sta     SCRMEM,X            ; Write to the first HALF_SIZE of the screen memory
    sta     SCRMEM+HALF_SIZE,X       ; Write to the second HALF_SIZE of the screen memory

    lda     #$06                        ; Load a with the colour of the characters to be displayed (blue)
    sta     CLRMEM,X                    ; Write to the first HALF_SIZE of the colour memory
    sta     CLRMEM+HALF_SIZE,X          ; Write to the second HALF_SIZE of the colour memory
    inx

    bne     initializeScreen    ; Loop until the counter overflows back to 0, then exit the loop

    ; TODO: simplify
    lda     #$05
    ;TOP
    sta     $1eb7               ; TOP LEFT CORNER
    sta     $1eb7+$1
    sta     $1eb7+$2
    sta     $1eb7+$3
    sta     $1eb7+$4
    sta     $1eb7+$5
    sta     $1eb7+$6

    ;LEFT SIDE
    sta     $1eb7+$16
    sta     $1eb7+$2c
    sta     $1eb7+$42
    sta     $1eb7+$58
    sta     $1eb7+$6e
    sta     $1eb7+$84

    ;BOTTOM
    sta     $1eb7+$84+$1
    sta     $1eb7+$84+$2
    sta     $1eb7+$84+$3
    sta     $1eb7+$84+$4
    sta     $1eb7+$84+$5
    sta     $1eb7+$84+$6

    ;RIGHT SIDE
    sta     $1eb7+$6+$16
    sta     $1eb7+$6+$2c
    sta     $1eb7+$6+$42
    sta     $1eb7+$6+$58
    sta     $1eb7+$6+$6e

    ldx     #$04
    ldy     #$04

    include "Render.s"

    lda     #$02
    sta     $1efc               ; MIDDLE
    lda     #$00
    sta     $1a00               ; eor #$01 every move
    jmp     inputLoop

shiftRightJMP:
    jmp     initSSR_R
shiftLeftJMP:
    jmp     initSSR_L
shiftUpJMP:
    jmp     initSSR_U
shiftDownJMP:
    jmp     initSSR_D

    include "MoveRight.s"
    jmp     loopH
    include "MoveLeft.s"
    jmp     loopH
    include "MoveUp.s"
    jmp     loopV
    include "MoveDown.s"

loopV:
    lda     #$40
    sta     $fc
    lda     #$10
    sta     $fd
    jsr     charShift_V

    lda     #$50
    sta     $fc
    jsr     charShift_V

    lda     #$30
    sta     $fd
    jsr     timer

    dec     $fe
    bne     loopV

    lda     $1a00
    eor     #$01
    sta     $1a00

    jmp     inputLoop                   ; jump to main routine

loopH:
    lda     #$40
    sta     $fc
    lda     #$10
    sta     $fd
    jsr     charShift_H

    lda     #$50
    sta     $fc
    jsr     charShift_H

    lda     #$30
    sta     $fd
    jsr     timer

    dec     $fe
    bne     loopH

    lda     $1a00
    eor     #$01
    sta     $1a00

    jmp     inputLoop                   ; jump to main routine

    include "CharacterMovement.s"
    include "Timer.s"

    org     $1600
/*
; "level 1"
frameBuffer0    .byte   $04, $04, $04, $04, $04, $04, $04
frameBuffer1    .byte   $04, $04, $04, $04, $03, $04, $04
frameBuffer2    .byte   $04, $04, $03, $03, $03, $04, $04
frameBuffer3    .byte   $04, $03, $03, $03, $03, $03, $04
frameBuffer4    .byte   $04, $03, $04, $03, $04, $03, $04
frameBuffer5    .byte   $04, $04, $04, $03, $04, $04, $04
frameBuffer6    .byte   $04, $04, $04, $04, $04, $04, $04
*/

/*
; "level 2"
frameBuffer0    .byte   $04, $04, $03, $03, $03, $04, $03
frameBuffer1    .byte   $04, $03, $04, $03, $03, $03, $04
frameBuffer2    .byte   $04, $03, $03, $04, $03, $04, $03
frameBuffer3    .byte   $04, $03, $03, $03, $03, $03, $04
frameBuffer4    .byte   $04, $04, $03, $04, $04, $03, $03
frameBuffer5    .byte   $04, $03, $03, $03, $04, $03, $04
frameBuffer6    .byte   $04, $03, $03, $03, $04, $03, $03
*/

; "level 3"
frameBuffer0    .byte   $04, $03, $03, $04, $03, $03, $03
frameBuffer1    .byte   $03, $03, $03, $04, $03, $03, $04
frameBuffer2    .byte   $04, $03, $04, $03, $04, $03, $03
frameBuffer3    .byte   $03, $03, $03, $03, $03, $03, $04
frameBuffer4    .byte   $04, $03, $03, $04, $03, $03, $03
frameBuffer5    .byte   $03, $03, $04, $03, $04, $03, $04
frameBuffer6    .byte   $04, $03, $03, $03, $03, $03, $03