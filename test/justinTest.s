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

    ldy     #$0b            ; number of amogus rows
bigAmogusLoop:
    ldx     #$0b            ; amogus counter
amogusLoop1:
    lda     #$42+2*(2-1)    ; set a to first character in new character set
    jsr     CHROUT
    lda     #$43+2*(2-1)    ; set a to second character in new character set
    jsr     CHROUT
    dex
    bne     amogusLoop1

    ldx     #$0b            ; amogus counter
amogusLoop2:
    lda     #$43+2*(2-1)    ; set a to first character in new character set
    jsr     CHROUT
    lda     #$42+2*(2-1)    ; set a to second character in new character set
    jsr     CHROUT
    dex
    bne     amogusLoop2
    dey
    bne     bigAmogusLoop

loop:

    lda     #$7f
    sta     $fc
    jsr     timer

    lda     #$c8
    sta     $fb
    lda     #$02
    sta     $fd
    jsr     charMidbyte     ; Format the identifier into low and high address bytes
    jsr     charShift_V

    lda     #$6a
    sta     $fb
    lda     #$02
    sta     $fd
    jsr     charMidbyte     ; Format the identifier into low and high address bytes
    jsr     charShift_H

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

    # Notes:    ---
    19 Bytes
*/
    org     $1491           ; Memory location of new code region
charMidbyte:
    ldx     #$03            ; Initialize counter while also setting up for ROR, since high nibble = 0 is all that matters
    stx     $fc             ; Store value in $fc for ROR
    lda     $fd             ; Load identifier of character to shift

    sec                     ; Set carry flag to ensure high nibble is 1, so the high nibble of the high byte is #$1*
    ror     $fd             ; Shift high nibble of identifier
cM_L:                       ; Perform shift 3 times
    ror     $fc
    lsr     $fd
    dex
    bne     cM_L
    ror     $fc             ; Shift low nibble of identifier
    rts

/*
    A.M.O.G.U.S. Character Horizontal Shift Routine (Advanced Movement Of Graphics Using Shift)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (2a = <-, 6a = ->) (OP code for ROL/ROR Indirect,y)
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
cSH_ByteLoop:
    lda     ($fc),y         ; Load byte from first character
    ror                     ; Shift it to put either bit 0/7 in the carry flag [SMC]
    ldx     #$01            ; Initialize counter to cycle through both characters
cSH_ShiftLoop:
    tya                     ; Swap y between first and second character
    eor     #$08
    tay

    lda     ($fc),y         ; Load byte from character indicated by y
    ror                     ; Shift it to rotate the carry flag in, and put bit 0/7 in the carry flag [SMC]
    sta     ($fc),y         ; Store byte back in character indicated by y, now shifted

    dex
    bpl     cSH_ShiftLoop    ; If we've looped through both characters, exit loop

    dey
    bpl     cSH_ByteLoop     ; If we've looped through all bytes, exit loop
    rts

/*
    V.E.N.T.E.D. Character Vertical Shift Routine (Vertical Ejection of Narrowly-Tiled Entity Data)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (c8 = v, 88 = ^) (OP code for INY/DEY)
                -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   None

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    33 Bytes
*/       
    org     $1551           ; Memory location of new code region
charShift_V:
    lda     $fb             ; Load direction to shift character
    ldy     #$0f            ; Initialize counter for all bytes in linked character set
    sta     $1551+$13       ; Store direction to shift character in the DEY/INY instruction [SMC]

cSV_StorageLoop:            ; Stores all bytes in the linked character set into $1000-$100f
    lda     ($fc),y         ; Load byte from character indicated by y
    sta     $1000,y         ; Store byte in corresponding location in $1000-$100f
    dey                     ; Decrement y until we've looped through all bytes
    bpl     cSV_StorageLoop ; If we've looped through all bytes, exit loop
    iny                     ; Increment y once, so that y is now #$00
cSV_ShiftLoop:
    lda     $1000,y         ; Load byte from $1000-$100f
    iny                     ; Increment/Decrement y to get the location in the character to store the byte [SMC]

                            ; Ensure that y in in range of $00-$0f
    tax                     ; Use x as temporary storage for a
    tya                     ; Transfer y to a so we can do math on it
    and     #$0f            ; Mask out the high nibble of y (now in a)
    tay                     ; Store y (currently in a) back in y
    txa                     ; Restore a from x

    sta     ($fc),y         ; Store byte in character indicated by y
    cpy     #$00            ; Check if we've looped through all bytes
    bne     cSV_ShiftLoop   ; If we have, exit loop
    rts

/*
    I.M.P.O.S.T.O.R. Character Flip Routine (Invertion Movement of Pre-Ordered, Shifted Tables Of Rasters)
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   $fe

    # Notes:    ---
    32 bytes
*/
    org     $1701
characterFlip:
    ldx     #$01            ; Initialize counter for address bytes in ROL instruction [SMC]
cF_ByteLoop:
    lda     $fc,x           ; Load address byte from $fc-$fd
    sta     $1701+$16,x     ; Store address byte in ROL instruction [SMC]
    dex     
    bpl     cF_ByteLoop     ; If we've looped through both address bytes, exit loop

    ldy     #$07            ; Initialize counter for all bytes in character
cF_LoadLoop:
    lda     #$07            ; Initialize counter for all bits in byte
    sta     $fe             ; Store counter in $fe for ROL instruction [SMC]
    tya                     ; Transfer y to x so we can use it in the ROL instruction
    tax
    lda     ($fc),y         ; Copy byte from character indicated by y into a
cF_ShiftLoop:
    ror                     ; Shift copy of byte in a to put bit 0 in the carry flag
    rol     $9999,x         ; Shift byte in character indicated by x to rotate the carry flag in [SMC]

    dec     $fe             ; Decrement counter (for all bits in byte)
    bpl     cF_ShiftLoop    ; If we've looped through all bits, exit loop

    dey                     ; Decrement y (for all bytes in character)
    bpl     cF_LoadLoop     ; If we've looped through all bytes, exit loop
    rts

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Number of ~2ms intervals you want to wait for

    & Location specific:    No
    % Alters:   $fb, $fc

    # Notes:    This is a blocking timer. It will not return until the timer has expired.
    9 Bytes
*/
    org     $1741           ; Memory location of new code region
timer:           
    dec     $fb             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fc             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine