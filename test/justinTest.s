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
CHROUT = $ffd2              ; kernal character output routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Data
*/
pad         .byte   $00, $00, $00 ; Padding so that next byte is on 8 byte boundary
    org     $1020
chr_1       .byte   $00, $3c, $26, $56, $56, $26, $3c, $24 ; sus?
chr_1_b     .byte   $00, $00, $00, $00, $00, $00, $00, $00 ; sus_v2?

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    lda     #$fc            
    sta     $9005           ; load custom character set
    jsr     $e55f           ; clear screen
    lda     #$42+2*(2-1)    ; set a to first character in new character set
    jsr     CHROUT
    lda     #$43+2*(2-1)    ; set a to second character in new character set
    jsr     CHROUT

    lda     #$02
    sta     $fd
    jsr     characterFlip

loop:

    lda     #$7f
    sta     $fc
    jsr     timer

    lda     #$02
    sta     $fd
    lda     #$7e
    sta     $fb
    lda     #$01
    sta     $fe

    jsr     charShift_H

    lda     #$7f
    sta     $fc
    jsr     timer

    lda     #$02
    sta     $fd
    lda     #$3e
    sta     $fb
    lda     #$00
    sta     $fe

    jsr     charShift_H

    jmp     loop

/*
    E.J.E.CT. Character Identifier Decoder Routine (Efficient Juggling of Expelled CharacTers)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fd | Character identifier byte
                <- $fc | Character low byte
                <- $fd | Character high byte

    & Location specific:    No
    % Alters:   $fc, $fd

    # Notes: ---
    19 Bytes
*/
    org     $1491           ; Memory location of new code region
charMidbyte:
    ldx     #$03            ; Initialize counter while also setting up for ROR, since high nibble = 0 is all that matters
    stx     $fc             ; Store value in $fd for ROR
    lda     $fd             ; Load identifier of character to shift

    sec                     ; Set carry flag to ensure high nibble is 1 (Math reasons)
    ror     $fd             ; Shift high nibble of identifier
cM_L:                       ; Perform shift 3 times     
    ror     $fc             ; --^
    lsr     $fd             ; --^
    dex                     ; --^
    bne     cM_L            ; --*
    ror     $fc             ; Shift low nibble of identifier
    rts

/*
    A.M.O.G.U.S. Character Horizontal Shift Routine (Advanced Movement Of Graphics Using Shift)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (3e = <-, 7e = ->) (OP code for ROR/ROL Absolute,x)
                -> $fc | Identifier of first linked character to shift ($1**0)
                -> $fe | Number of times to shift character -1 (00 -> once, 01 -> twice, etc.)

    & Location specific:    Yes
    % Alters:   $fc, $fd, $fe

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    53 Bytes
*/           
    org     $1501           ; Memory location of new code region
charShift_H:
    jsr     charMidbyte     ; Format the identifier into low and high address bytes

cs_hRepeat:                 ; Repeat the following code for the number of times specified by $fe
    ldx     #$07            ; Initialize counter for the loop to transfer the ROR/ROL instructions (3)
cS_hA:                      ; Here we prep the two ROR/ROL instructions
    lda     $f6,x           ; Get the op code and character address bytes from zero page
    sta     $1501+$22,x     ; Store first instruction set into first ROR/ROL [SMC]
    cpx     #$06            ; Check if we're reading the low address byte
    bne     cS_hB           ; If not, skip the next instruction
    ora     #$08            ; Add 8 to the low address byte, changing $1**0 into $1**8
cS_hB:
    sta     $1501+$25,x     ; Store second instruction set into second ROR/ROL [SMC]
    cpx     #$05            ; Check if we're reading the high address byte
    bne     cS_hC           ; If not, skip the next two instructions
    ldx     #$08            ; Set x so that the address we write the last instruction to is the single ROR/ROL [SMC]
    eor     #$14            ; Magic number that turns 7e -> 6a and 3e -> 2a for the single ROR/ROL instruction
cS_hC:
    sta     $1501+$1e,x     ; Store the first LDA/ROR/ROL instruction dual line set [SMC]
    dex                     ; Decrement counter
    cpx     #$07            ; Check if we're done
    bne     cS_hA           ; Loop until counter underflows, indicating that we've processed all 3 bytes

cS_hMain:                   ; x is now 7, so we can use it as the counter for the main loop
    lda     $9999,x         ; Load the second linked character [SMC]
    ror                     ; Move bit 0/7 to carry depending on ROR/ROL [SMC]
    ror     $9999,x         ; Rotate out of first character, shifting in the carry [SMC]
    ror     $9999,x         ; Rotate into second character [SMC]
    dex                     ; Decrement counter
    bpl     cS_hMain        ; If counter hasn't underflowed, loop
    dec     $fe             ; Decrement the number of times to shift
    bpl     cs_hRepeat      ; If we still have to shift, loop
    rts         

/*
    V.E.N.T.E.D. Character Vertical Shift Routine (Vertical Ejection of Narrowly-Tiled Entity Data)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (07 = ^, else = v)
                -> $fc | Identifier of first linked character to shift ($1**0)

    & Location specific:    Yes
    % Alters:   $fc, $fd

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    75 Bytes
*/
    org     $1551           ; Memory location of new code region
charShift_V:
    jsr     charMidbyte     ; Format the identifier into low and high address bytes

    ldx     #$01

    lda     $1020
    sta     $fb

    lda     #$10
    sta     $fd
LLL:
    lda     $1020,x
    dex

    txa
    and     #$0f
    tax

    sta     $1020,x
    inx
    inx

    txa
    and     #$0f
    tax

    dec     $fd
    bne     LLL

    lda     $fb
    sta     $102f

    ; lda     $1029
    ; sta     $1028

    ; lda     $102a
    ; sta     $1029

    ; lda     $102b
    ; sta     $102a

    ; lda     $102c
    ; sta     $102b

    ; lda     $102d
    ; sta     $102c

    ; lda     $102e
    ; sta     $102d

    ; lda     $102f
    ; sta     $102e

    ; lda     $1020
    ; sta     $102f

    ; lda     $1021
    ; sta     $1020

    ; lda     $1022
    ; sta     $1021

    ; lda     $1023
    ; sta     $1022

    ; lda     $1024
    ; sta     $1023

    ; lda     $1025
    ; sta     $1024

    ; lda     $1026
    ; sta     $1025

    ; lda     $1027
    ; sta     $1026

    ; lda     #$00
    ; sta     $1027

    rts

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Number of ~2ms intervals you want to wait for

    & Location specific:    No
    % Alters:   $fb, $fc

    # Notes: This is a blocking timer. It will not return until the timer has expired.
    9 Bytes
*/
    org     $1601           ; Memory location of new code region
timer:           
    dec     $fb             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fc             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine

/*
    I.M.P.O.S.T.O.R. Character Flip Routine (Invertion Movement of Pre-Ordered, Shifted Tables Of Rasters)
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Character identifier byte

    & Location specific:    Yes
    % Alters:   $fc, $fd

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    38 bytes
*/
    org     $1621           ; Memory location of new code region [TODO: Better comments]
characterFlip:
    jsr     charMidbyte     ; Format the identifier into low and high address bytes

    ldx     #$01            ; Initialize counter for the loop to transfer LDA and STA instructions
cF_N:
    lda     $fc,x           ; Load address bytes of character to flip
    sta     $1621+$13,x     ; Store value in org + $13 [SMC]
    sta     $1621+$20,x     ; Store value in org + $20 [SMC]
    dex                     ; Decrement counter
    bpl     cF_N            ; If counter did not underflow yet, loop

    ldx     #$07            ; Set x to 7 (The number of bytes we need to flip)
cF_M:
    lda     $9999,x         ; Load byte to be flipped [SMC]
    sta     $fc             ; Store copy of byte to be flipped in $fc
    ldy     #$07            ; Set y to 8 (The number of bits we need to flip)
cF_L:
    lsr     $fc             ; Math stuff to get it to work
    rol                     ; --^
    dey                     ; --^            
    bpl     cF_L            ; --*
    sta     $9999,x         ; Store flipped byte [SMC]
    dex                     ; Decrement x
    bne     cF_M            ; If x is not zero, loop
    rts


