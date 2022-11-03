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
    Utility Routines
*/
stubend:
    dc.w    0                           ; insert null byte

/* 
    Global Definitions
*/
SCRMEM = $1e00                          ; Screen memory address
CLRMEM = $9600                          ; Colour memory address 
HALF_SIZE = $0100                       ; Half the screen size

TITLE_LOC = $31                         ; Title location in screen memory
TEAM_LOC = $5b                          ; Team name location in screen memory
YEAR_LOC = $76                          ; Year location in screen memory

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
    
                                        ; Was not able to shorten these three nearly identical chunks of code :(
                                        ; We are reading from bottom of screen to top of screen because of the stack
    ldx     #$3                         ; Initialize the counter used to loop through the year data (4 bytes, so x = 4-1)
writeYear:
    pla                                 ; Pop the bottom nibble off the stack
    tay                                 ; Transfer the bottom nibble to the Y register
    lda     ($fb),y                     ; Load the bottom nibble's character from the lookup table
    sta     SCRMEM+YEAR_LOC,x                ; Write the character to the screen memory
    dex                                 ; Decrement the counter
    bpl     writeYear                   ; Loop back to the top of the year writing routine if the counter did not underflow

    ldx     #$10                        ; Initialize the counter used to loop through the team name data (17 bytes, so x = 17-1)
writeName:
    pla                                 ; Pop the bottom nibble off the stack    
    tay                                 ; Transfer the bottom nibble to the Y register                       
    lda     ($fb),y                     ; Load the bottom nibble's character from the lookup table
    sta     SCRMEM+TEAM_LOC,x                ; Write the character to the screen memory
    dex                                 ; Decrement the counter
    bpl     writeName                   ; Loop back to the top of the name writing routine if the counter did not underflow

    ldx     #$0c                        ; Initialize the counter used to loop through the team name data (13 bytes, so x = 13-1)
writeTitle:                     
    pla                                 ; Pop the bottom nibble off the stack            
    tay                                 ; Transfer the bottom nibble to the Y register               
    lda     ($fb),y                     ; Load the bottom nibble's character from the lookup table
    sta     SCRMEM+TITLE_LOC,x                ; Write the character to the screen memory
    dex                                 ; Decrement the counter 
    bpl     writeTitle                  ; Loop back to the top of the title writing routine if the counter did not underflow

infLoop:
    bne    infLoop                      ; Yeeehhhhawwwww! (infinite loop, final resting place of the program)


/*
    Title Data
*/
lC101d  .byte   $3d, $33, $74, $0c, $64, $0e, $79, $ac, $04, $9a, $d5, $60, $84, $8a, $bf, $21, $22