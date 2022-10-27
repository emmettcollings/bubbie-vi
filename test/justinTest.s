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

loop:

    lda     #$7f
    sta     $fc
    jsr     timer

    lda     #$2a
    sta     $fb
    lda     #$02
    sta     $fd
    jsr     charMidbyte     ; Format the identifier into low and high address bytes
    jsr     charShift_V

    ; lda     #$02
    ; sta     $fd
    ; jsr     charMidbyte     ; Format the identifier into low and high address bytes
    ; jsr     characterFlip

    jmp     loop

/*
    E.J.E.CT. Character Identifier Decoder Routine (Efficient Juggling of Expelled CharacTers)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fd | Character identifier byte
                <- $fc | Character address low byte
                <- $fd | Character address high byte

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
    
    ~ Usage:    -> $fb | Direction to shift character (2a = <-, 6a = ->) (OP code for ROR/ROL Indirect,y)
                -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   None

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    31 Bytes
*/           
    org     $1501           ; Memory location of new code region
charShift_H:
    lda     $fb             ; Load direction to shift character
    ldy     #$07            ; Initialize counter for all bytes in character (Initialized to the first character)
    sta     $1501+$0c       ; Store direction to shift character in the ROR/ROL instructions [SMC]
    sta     $1501+$15
cS_ByteLoop:
    lda     ($fc),y         ; Load byte from first character
    ror                     ; Shift it to put either bit 0/7 in the carry flag [SMC]
    ldx     #$01            ; Initialize counter to cycle through both characters
cS_ShiftLoop:
    tya                     ; Swap y between first and second character
    eor     #$08
    tay

    lda     ($fc),y         ; Load byte from character indicated by y
    ror                     ; Shift it to rotate the carry flag in, and put bit 0/7 in the carry flag [SMC]
    sta     ($fc),y         ; Store byte back in character indicated by y, now shifted

    dex
    bpl     cS_ShiftLoop    ; If we've looped through both characters, exit loop

    dey
    bpl     cS_ByteLoop     ; If we've looped through all bytes, exit loop
    rts

/*
    V.E.N.T.E.D. Character Vertical Shift Routine (Vertical Ejection of Narrowly-Tiled Entity Data)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (07 = ^, else = v)
                -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   $fe

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    75 Bytes
*/
    org     $1551           ; Memory location of new code region
charShift_V:
    lda     $1020
    sta     $fe

    ldy     #$0e
cS_A:
    lda     $1021,y
    sta     $1020,y
    dey
    bpl     cS_A

    lda     $fe
    sta     $102f

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
    org     $1701           ; Memory location of new code region
timer:           
    dec     $fb             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fc             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine

/*
    I.M.P.O.S.T.O.R. Character Flip Routine (Invertion Movement of Pre-Ordered, Shifted Tables Of Rasters)
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   $fe

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    33 bytes
*/
    org     $1721
characterFlip:
    ldx     #$01
cF_A:
    lda     $fc,x
    sta     $1721+$17,x
    dex
    bpl     cF_A

    ldy     #$07
cF_B:
    lda     #$07
    sta     $fe
    tya
    tax
    lda     ($fc),y
cF_C:
    clc
    ror
    rol     $9999,x

    dec     $fe
    bpl     cF_C

    dey
    bpl     cF_B     
    rts

