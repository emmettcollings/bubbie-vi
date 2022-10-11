/*  
 * Draw the whole screen by drawing 23 lines. Need to think about the effects
 * our subroutines have on the xy registers, might mess things up if they get 
 * modified by called SRs
 */
    processor 6502          ; tell dasm we are writing 6502 asm
    incdir "../../lib"
/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

stubend:    
    dc.w    0               ; insert null byte

LOC = $fd

/* 
 * Our main!
 */
start: 
    lda     #$10            ; screen data location
    sta     LOC
    lda     #$11            
    sta     LOC + $01

    lda     #$00            ; screen mem
    sta     SM
    lda     #$1e            
    sta     SM + $01

    jsr     drawScreen
    rts                     ; return to caller

/*
 * Input: none :), probably best to keep our frame buffer? in a fixed location
 *        in memory
 */
drawScreen:
    lda     #0              ; start with first line
    sta     $1d00
    ldx     #0

drawScreen.loop:
    ldy     $1d00           ; transfer offset to y
    jsr     drawLine        ; draw line
    inx                     ; increment x to track loops
    cpx     #$17            ; 23 lines
    beq     drawScreen.done
    lda     $1d00           ; not a fan of this there's probably a better way
                            ; than just load storing a bunch
    adc     #$16
    sta     $1d00
    jmp     drawScreen.loop

drawScreen.done:
    rts

    include "globals.s"
    include "drawLine.s"

    org     $1110
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30

    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30

