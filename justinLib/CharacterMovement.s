/*
    Size: 96 bytes = 0x60
*/
VERTICAL_TEMP = $1000
    org     $1581           ; Memory location of new code region

/*
    A.M.O.G.U.S. Character Horizontal Shift Routine (Advanced Movement Of Graphics Using Shift)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (2a = <-, 6a = ->) (OP code for ROL/ROR Indirect,y)
                -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   None

    # Notes:    ---
    31 Bytes
*/           
charShift_H:
    lda     $fb             ; Load direction to shift character
    ldy     #$07            ; Initialize counter for all bytes in character (Initialized to the first character)
    sta     cSH_R1          ; Store direction to shift character in the ROR/ROL instructions [SMC]
    sta     cSH_R2
cSH_ByteLoop:
    lda     ($fc),y         ; Load byte from first character
cSH_R1:     ror             ; Shift it to put either bit 0/7 in the carry flag [SMC]
    ldx     #$01            ; Initialize counter to cycle through both characters
cSH_ShiftLoop:
    tya                     ; Swap y between first and second character by flipping bit 3
    eor     #%00001000
    tay

    lda     ($fc),y         ; Load byte from character indicated by y
cSH_R2:     ror             ; Shift it to rotate the carry flag in, and put bit 0/7 in the carry flag [SMC]
    sta     ($fc),y         ; Store byte back in character indicated by y, now shifted

    dex
    bpl     cSH_ShiftLoop   ; If we've looped through both characters, exit loop

    dey
    bpl     cSH_ByteLoop    ; If we've looped through all bytes, exit loop
    rts

/*
    V.E.N.T.E.D. Character Vertical Shift Routine (Vertical Ejection of Narrowly-Tiled Entity Data)
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Direction to shift character (c8 = v, 88 = ^) (OP code for INY/DEY)
                -> $fc | Character address low byte
                -> $fd | Character address high byte

    & Location specific:    Yes
    % Alters:   None

    # Notes:    ---
    33 Bytes
*/       
charShift_V:
    lda     $fb             ; Load direction to shift character
    ldy     #$0f            ; Initialize counter for all bytes in linked character set
    sta     cSV_R1          ; Store direction to shift character in the DEY/INY instruction [SMC]

cSV_StorageLoop:            ; Stores all bytes in the linked character set into $1000-$100f
    lda     ($fc),y         ; Load byte from character indicated by y
    sta     VERTICAL_TEMP,y ; Store byte in corresponding location in $1000-$100f
    dey                     ; Decrement y until we've looped through all bytes
    bpl     cSV_StorageLoop ; If we've looped through all bytes, exit loop
    iny                     ; Increment y once, so that y is now #$00
cSV_ShiftLoop:
    lda     VERTICAL_TEMP,y ; Load byte from $1000-$100f

cSV_R1:     iny             ; Increment/Decrement y to get the location in the character to store the byte [SMC]
                            
                            ; Ensure that y in in range of $00-$0f
    pha                     ; push a to the stack to preserve it
    tya                     ; Transfer y to a so we can do math on it
    and     #%00001111      ; Mask out the high nibble of y (now in a)
    tay                     ; Store y (currently in a) back in y
    pla                     ; Restore a from the stack

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
characterFlip:
    ldx     #$01            ; Initialize counter for address bytes in ROL instruction
cF_ByteLoop:
    lda     $fc,x           ; Load address byte from $fc-$fd
    sta     cF_R1+$1,x      ; Store address byte in ROL instruction [SMC]
    dex     
    bpl     cF_ByteLoop     ; If we've looped through both address bytes, exit loop

    ldy     #$07            ; Initialize counter for all bytes in character
cF_LoadLoop:
    lda     #$07            ; Initialize counter for all bits in byte
    sta     $fe             ; Store counter in $fe for ROL instruction
    tya                     ; Transfer y to x so we can use it in the ROL instruction
    tax
    lda     ($fc),y         ; Copy byte from character indicated by y into a
cF_ShiftLoop:
    ror                     ; Shift copy of byte in a to put bit 0 in the carry flag
cF_R1:      rol     $9999,x ; Shift byte in character indicated by x to rotate the carry flag in [SMC]

    dec     $fe             ; Decrement counter (for all bits in byte)
    bpl     cF_ShiftLoop    ; If we've looped through all bits, exit loop

    dey                     ; Decrement y (for all bytes in character)
    bpl     cF_LoadLoop     ; If we've looped through all bytes, exit loop
    rts