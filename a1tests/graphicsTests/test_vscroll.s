/*  
 * Vertically scrolling a solid block
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

CHRPTR = $9005
CHRMEM = $1c00
SCRMEM = $1e00
CURR   = $1b03

/* 
 * Steps: load custom chars -> make em scroll
 */
start: 
    lda     #$ff
    sta     CHRPTR
    jsr     initScreen
    lda     #$08        ; init with spaces
    jsr     clearScreen
    lda     #$00
    sta     SCRMEM
    sta     CURR

wait:
    nop
    jmp     wait

    SUBROUTINE
/*
 * Scrolls a down by one character
 */
scrollDown:
    tay             ; store offset
    ldx     #$09    
    lda     #$01    
.loop:
    sta     $1b00   ; waste some time
    sty     $1b01
    stx     $1b02
    jsr     busy
    lda     $1b00
    ldy     $1b01
    ldx     $1b02

    sta     SCRMEM,y
    adc     #$07
    sta     SCRMEM+22,y
    sbc     #$06
    dex
    bne     .loop
    
    rts


    SUBROUTINE
/*
 * Scrolls a up by one character
 */
scrollUp:
    tay             ; store offset
    ldx     #$09    
    lda     #$0f    
.loop:
    sta     $1b00   ; waste some time
    sty     $1b01
    stx     $1b02
    jsr     busy
    lda     $1b00
    ldy     $1b01
    ldx     $1b02

    sta     SCRMEM,y
    sbc     #$07
    sta     SCRMEM-22,y
    adc     #$06
    dex
    bne     .loop
    
    rts

    SUBROUTINE
busy:
    ldx     #$ff
    ldy     #$20
.loop:
    dex
    bne     .loop
    dey
    bne     .loop
    rts

    include "initScreen.s"

; char definitions
    org     CHRMEM
ublk0   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
ublk1   .byte   $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff
ublk2   .byte   $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
ublk3   .byte   $00, $00, $00, $ff, $ff, $ff, $ff, $ff
ublk4   .byte   $00, $00, $00, $00, $ff, $ff, $ff, $ff
ublk5   .byte   $00, $00, $00, $00, $00, $ff, $ff, $ff
ublk6   .byte   $00, $00, $00, $00, $00, $00, $ff, $ff
ublk7   .byte   $00, $00, $00, $00, $00, $00, $00, $ff

space   .byte   $00, $00, $00, $00, $00, $00, $00, $00

bblk7   .byte   $ff, $00, $00, $00, $00, $00, $00, $00
bblk6   .byte   $ff, $ff, $00, $00, $00, $00, $00, $00
bblk5   .byte   $ff, $ff, $ff, $00, $00, $00, $00, $00
bblk4   .byte   $ff, $ff, $ff, $ff, $00, $00, $00, $00
bblk3   .byte   $ff, $ff, $ff, $ff, $ff, $00, $00, $00
bblk2   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $00, $00
bblk1   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
bblk0   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
