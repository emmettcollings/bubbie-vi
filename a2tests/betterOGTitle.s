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
CLS    = $e55f                 ; kernal clear screen routine
SCRMEM = $1e00
BUBBIESTART = $1e31     ; start of the line that says BUBBIE THE VI
TEAMSTART = $1e5b
YEARSTART = $1e76
CLRMEM = $9600
size   = $100     ; 256 byte offset so that we write both halves of mem chunk
                  ; in one loop iteration

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

    lda     #$06
    jsr     colorScreen

    lda     #$41
    sta     BUBBIESTART

wait:
    nop
    jmp     wait

/*
 * Writes whatever is in a to 512 bytes of color mem
 */
colorScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

.loop:      
    sta     CLRMEM,X          ; write in first half
    sta     CLRMEM+size,X     ; write in second half
    inx
    bne     .loop
    rts

/*
    ldx     #$0d
bubbie:
    lda     $l100d 
    sta     BUBBIESTART
    dex     
    bne     bubbie
    */

