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
chr_1       .byte   $ff, $3c, $26, $56, $56, $26, $3c, $24 ; sus?
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

    lda     #$02
    sta     $fd
    jsr     characterFlip

    lda     #$7f
    sta     $fc
    jsr     timer

    lda     #$02
    sta     $fd
    lda     #$07
    sta     $fb

    jsr     charShift_V
    
    lda     #$02
    sta     $fd
    jsr     characterFlip

    jmp     loop

/*
    E.J.E.Ct. Character Identifier Decoder Routine (Efficient Juggling of Expelled Characters)
    @ Author:   Justin Parker
    
    ~ Usage:    $fd | Character identifier byte

    & Location specific:    No
    % Alters:   $fc, $fd

    # Notes: Returns low byte in $fc and high byte in $fd
    19 Bytes
*/
    org     $1491           ; Memory location of new code region
charMidbyte:
    ldx     #$03            ; Initialize counter while also setting up for ror, since high nibble = 0 is all that matters
    stx     $fc             ; Store value in $fd for ror
    lda     $fd             ; Load identifier of first character to shift

    sec                     ; Set carry flag to ensure high nibble is 1
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
    
    ~ Usage:    $fb     | Direction to shift character (3e = <-, 7e = ->)
                $fc     | Identifier of first linked character to shift ($1**0)

    & Location specific:    Yes
    % Alters:   $fb, $fc, $fd

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    34 Bytes
*/
    org     $1501           ; Memory location of new code region
charShift_H:
    jsr     charMidbyte     ; Format the identifier into low and high address bytes

    ldx     #$02            ; Initialize counter for the loop to transfer ROx instructions
cS_hA:
    lda     $fb,x           ; Get the op code and character address bytes from zero page
    sta     $1501+$18,x     ; Store value in org + $18 [SMC]
    cpx     #$01            ; Check if counter is 1, when we want to add 8 to the character address
    bne     cS_hB           ; If not, skip the next instruction
    ora     #$08            ; Add 8 to the low address byte (Since the linked character is stored at $***0)
cS_hB:
    sta     $1501+$1b,x     ; Store value in org + $1b [SMC]
    dex                     ; Decrement counter
    bpl     cS_hA           ; If counter is not 0, loop

    ldx     #$07            ; Set x to 7 (The number of bytes needed to ROx)
cS_hC:
    ror     $1234,x         ; Rotate out of first character [SMC]
    rol     $8765,x         ; Rotate into second character [SMC]
    dex                     ; Decrement x
    bpl     cS_hC           ; If x hasn't underflowed, loop
    rts                     

/*
    V.E.N.T.E.D. Character Vertical Shift Routine (Vertical Ejection of Narrowly-Tiled Entity Data)
    @ Author:   Justin Parker
    
    ~ Usage:    $fb     | Direction to shift character (07 = ^, else = v)
                $fc     | Identifier of first linked character to shift ($1**0)

    & Location specific:    Yes
    % Alters:   $fb, $fc, $fd

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    75 Bytes
*/
    org     $1531           ; Memory location of new code region
charShift_V:
    jsr     charMidbyte     ; Format the identifier into low and high address bytes

    lda     #$07            ; Initialize with up (A must be set to $07 for the direction to be up)
    ldx     #$88
    ldy     #$ff      

    cmp     $fb
    beq     cS_vA           ; $fb == $07, (Character shifts up)

    lda     #$00            ; Change to down
    ldx     #$c8
    ldy     #$08
cS_vA:
    sta     $1531+$2e       ; Store value in org + #2e [SMC]
    stx     $1531+$36       ; Store value in org + $36 [SMC]
    sty     $1531+$38       ; Store value in org + $38 [SMC]

    ldx     #$02            ; Initialize counter for the loop
cS_vB:
    lda     $fb,x           ; Get the op code and character address bytes from zero page
    sta     $1531+$2f,x     ; Store value in org + $2f [SMC]
    sta     $1531+$32,x     ; Store value in org + $32 [SMC]
    txa                     ; Ensures A is $01 a few lines down
    dex
    bne     cS_vB           ; If not, skip the next instruction

    sta     $fd             ; A is $01 here
    txa                     ; A is set to $00, since x is $00
cS_vC:
    ldy     #$08            ; Initialize counter for the loop [SMC]
cS_vD:
    ldx     $1234,y         ; Shift all the character bytes over by 1 address [SMC]
    sta     $8765,y         ; --^ [SMC]
    txa 
    dey                     ; Decrement/Increment counter [SMC]
    cpy     #$00            ; Check if counter is finished [SMC]
    bne     cS_vD           ; If not, loop

    lda     $fc             ; Load identifier of first character to shift
    ora     #$08            ; Add 8 to the low address byte (Since the linked character is stored at $***0)
    sta     $1531+$30       ; Store value in org + $30 [SMC]
    sta     $1531+$33       ; Store value in org + $33 [SMC]
    txa
    dec     $fd             ; Decrement A (Indicates first or second time through loop)
    bpl     cS_vC           ; If loop hasn't been repeated, loop
    rts

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    $fc | Number of ~2ms intervals you want to wait for

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

    ~ Usage:    $fc | Character identifier byte

    & Location specific:    Yes
    % Alters:   $fc, $fd

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    38 bytes
*/
    org     $1621           ; Memory location of new code region
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
    lda     $8765,x         ; Load byte to be flipped [SMC]
    sta     $fc             ; Store copy of byte to be flipped in $fc
    ldy     #$08            ; Set y to 8 (The number of bits we need to flip)
cF_L:
    lsr     $fc             ; Math stuff to get it to work
    rol                     ; --^
    dey                     ; --^            
    bne     cF_L            ; --*
    sta     $8765,x         ; Store flipped byte [SMC]
    dex                     ; Decrement x
    bne     cF_M            ; If x is not zero, loop
    rts


