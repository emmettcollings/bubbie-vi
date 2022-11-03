/*
    Processor Information
*/
    processor   6502                    ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001                       ; mem location of user region
    dc.w    stubend
    dc.w    1                           ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4125", 0              ; allocate bytes. 4125 = 101d

/* 
    Global Definitions
*/
SCRMEM = $1e00                          ; screen memory address
CLRMEM = $9600                          ; colour memory address 
HALF_SIZE = $0100                       ; half the screen size

/*
    Utility Routines
*/
stubend:
    dc.w    0                           ; insert null byte

/*
    Lookup Table
    T[0] = _
    T[1] = 0
    T[2] = 2
    T[3] = b
    T[4] = e
    T[5] = g
    T[6] = h
    T[7] = i
    T[8] = m
    T[9] = n
    T[a] = o
    T[b] = r
    T[c] = t
    T[d] = u
    T[e] = v
    T[f] = y
*/
    dc.b   $20, $30, $32, $02, $05, $07, $08, $09, $0d, $0e, $0f, $12, $14, $15, $16, $19

/*
    Main Routine
*/
start: 
    ldx     #$00                        ; Initialize the counter
initializeScreenAndColour:    
    lda     #$20                        ; Load a with a space to fill the screen with
    sta     SCRMEM,X                    ; Write to the first half of the screen memory
    sta     SCRMEM+HALF_SIZE,X          ; Write to the second half of the screen memory

    lda     #$06                        ; Load a with the colour of the characters to be displayed (blue)
    sta     CLRMEM,X                    ; Write to the first half of the colour memory
    sta     CLRMEM+HALF_SIZE,X          ; Write to the second half of the colour memory
    inx
    bne     initializeScreenAndColour   ; Loop until the counter overflows back to 0, then exit the loop

    lda     #$0d                        ; Load $fb and $fc with the high and low bytes of the lookup table for indirection
    sta     $fb
    lda     #$10
    sta     $fc

    ldx     #$00                        ; Initialize the counter used to loop through the title data
loadOntoStack:
    lda     lC101d,x                    ; Load the next byte from the title data
    lsr                                 ; Shift the high nibble into the bottom nibble, and discard the bottom nibble
    lsr
    lsr
    lsr
    pha                                 ; Push the high nibble onto the stack
    lda     lC101d,x                    ; Reload the same byte byte from the title data
    and     #%00001111                  ; Mask the bottom nibble
    pha                                 ; Push the bottom nibble onto the stack

    inx                                 ; We've retrieved all the data we need from this byte, so increment the counter
    cpx     #$11                        ; Check if we've reached the end of the title data
    bne     loadOntoStack               ; If not, loop back to the top of the decompression routine

    ldx     #$3                         
writeYear:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$76,x
    dex
    bpl     writeYear

    ldx     #$10
writeName:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$5b,x
    dex
    bpl     writeName

    ldx     #$0c
writeTitle:
    pla
    tay
    lda     ($fb),y
    sta     SCRMEM+$31,x
    dex
    bpl     writeTitle

infLoop:
    bne    infLoop   ; yeeehhhhawwwww!


/*
    Title Data
*/
lC101d  .byte   $3d, $33, $74, $0c, $64, $0e, $79, $ac, $04, $9a, $d5, $60, $84, $8a, $bf, $21, $22