/*  
 * Horizontally scrolling a solid block
 */
    processor 6502          ; tell dasm we are writing 6502 asm
    incdir "../lib"

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

rightLoop:
    lda     CURR
    cmp     #$14
    beq     leftLoop
    inc     CURR
    jsr     scrollRight
    jmp     rightLoop

leftLoop:
    lda     CURR
    cmp     #$00
    beq     wait
    dec     CURR
    jsr     scrollLeft
    jmp     leftLoop


wait:
    nop
    jmp     wait


    SUBROUTINE
/*
 * Scrolls a right by one character
 */
scrollRight:
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
    sta     SCRMEM+1,y
    sbc     #$06
    dex
    bne     .loop
    
    rts


    SUBROUTINE
/*
 * Scrolls a left by one character
 */
scrollLeft:
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
    sta     SCRMEM-1,y
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
rblk0   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
rblk1   .byte   $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
rblk2   .byte   $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
rblk3   .byte   $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
rblk4   .byte   $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
rblk5   .byte   $07, $07, $07, $07, $07, $07, $07, $07
rblk6   .byte   $03, $03, $03, $03, $03, $03, $03, $03
rblk7   .byte   $01, $01, $01, $01, $01, $01, $01, $01

space   .byte   $00, $00, $00, $00, $00, $00, $00, $00

lblk7   .byte   $80, $80, $80, $80, $80, $80, $80, $80
lblk6   .byte   $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
lblk5   .byte   $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
lblk4   .byte   $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
lblk3   .byte   $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8
lblk2   .byte   $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
lblk1   .byte   $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
lblk0   .byte   $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

        .byte   $ff, $81, $81, $81, $81, $81, $81, $ff
