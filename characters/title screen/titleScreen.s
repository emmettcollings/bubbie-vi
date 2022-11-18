initiializeTitleScreen:
    lda     #$20                        ; Load a with a space to fill the screen with
    sta     SCRMEM,X                    ; Write to the first half of the screen memory
    sta     SCRMEM+HALF_SIZE,X          ; Write to the second half of the screen memory

    lda     #$06                        ; Load a with the colour of the characters to be displayed (blue)
    sta     CLRMEM,X                    ; Write to the first half of the colour memory
    sta     CLRMEM+HALF_SIZE,X          ; Write to the second half of the colour memory
    inx
    bne     initiializeTitleScreen      ; Loop until the counter overflows back to 0, then exit the loop

    ldy     #$00                        ; Initialize pointer to: first byte of data to read, screen memory to write, and
    sty     $fc                         ; indicator for which part of the screen to write to (upper or lower)
    sty     $fd

mainTitleScreenLoop:
    lda     lC1101+$01,y                ; Read the length byte from the next chunk of data
    cmp     #$00                        ; If the length byte is 0, then we have reached the end of the data

infLoop:
    beq     keyCheck                    
    tax                                 ; Copy the length byte to the X register so we can get the actual byte in a
    lda     lC1101,y                    ; Read the actual byte to be displayed
    iny                                 ; Increment the data pointer twice (since we read in two consecutive bytes at the same time)
    iny
    sty     $fb                         ; Store the data pointer in $fb
    ldy     $fc                         ; Load the screen memory pointer into Y

writeToScreenLoop:
    pha                                 ; Push the byte to be displayed onto the stack, so we can first check if we are on the 
    lda     $fd                         ; upper or lower half of the screen
    cmp     #$00                        ; If we are on the upper half of the screen
    bne     writeToLowerScreen          ; If we aren't, jump to the lower half of the screen
    pla                                 ; But if we're here we're on the upper half, so pull the byte to be displayed off the stack
    sta     SCRMEM,y                    ; Write it to the upper half of the screen
    jmp     wroteToUpperScreen          

writeToLowerScreen:
    pla                                 ; Pull the byte to be displayed off the stack
    sta     SCRMEM+HALF_SIZE,y          ; Write it to the lower half of the screen

wroteToUpperScreen:
    iny                                 ; Increment the screen memory pointer
    bne     swapScreenLowHigh           ; If the screen memory pointer didn't overflow, then we're done writing to the screen
    inc     $fd                         ; If the screen memory pointer did overflow, then we're now on the lower half of the screen

swapScreenLowHigh:
    dex                                 ; Decrement the length byte
    bne     writeToScreenLoop           ; If the length byte isn't zero, keep looping
    sty     $fc                         ; We're now done with this byte pair, so store the screen memory pointer in $fc
    ldy     $fb                         ; Load the data pointer back into Y
    jmp     mainTitleScreenLoop         ; Reset back to the beginning of the main loop

titleScreen:
    jmp     initiializeTitleScreen
    jsr     keyCheck
    
keyCheck:
    lda     $cb
    cmp     #$40
    beq     keyCheck
    jmp     gameLoop

       
lC1101      
   .byte   $20, $38 ; first 2 lines (and start of 3rd)
    dc.b    $66, $04, $20, $11 ; 3rd line (and start of 4th)
    dc.b    $66, $01, $20, $04, $66, $01, $20, $0F ; 4th line (and start of 5th)
    dc.b    $66, $01, $20, $01,$51,01,$20,$01, $51, $01, $20, $01, $66, $01, $20, $0F ; 5th line (and start of 6th)
    dc.b    $66, $01, $20, $06, $66, $01, $20, $09 ; 6th line (and start of 7th)
    dc.b    $66, $01, $20, $05, $66, $02, $20, $02, $66, $02, $20, $09 ; 7th line (and start of 8th)
    dc.b    $66, $01, $20, $01, $66, $01, $20, $06, $66, $02, $20, $0B ; 8th line (and start of 9th)
    dc.b    $66, $01, $20, $02, $66, $08, $20, $0B ; 9th line (and start of 10th)
    dc.b    $66, $01, $20, $0A, $66, $01, $20, $0B ; 10th line (and start of 11th)
    dc.b    $66, $01, $62, $01, $20, $05, $62, $01, $20, $03, $66, $01, $20, $0A ; 11th line (and start of 12th)
    dc.b    $66, $01, $20, $01, $62, $01, $20, $03, $62, $01, $20, $04, $66, $01, $20, $0B ; 12th line (and start of 13th)
    dc.b    $66, $01, $20, $01, $62, $03, $20, $04, $66, $01, $20, $0C ; 13th line (and start of 14th)
    dc.b    $66, $01, $20, $08, $66, $01, $20, $0D ; 14th line (and start of 15th)
    dc.b    $66, $02, $20, $04, $66, $02, $20, $10 ; 15th line (and start of 16th)
    dc.b    $66, $04, $20, $23 ; 16th line, 17th line, 18th line (and start of 19th)
    dc.b    $02, $01, $15, $01, $02, $02, $09, $01, $05, $01, $20, $01, $14, $01, $08, $01, $05, $01, $20, $01, $16, $01, $09, $01, $20, $07 ; 19th line (and start of 20th, bubbie)
    dc.b    $0e, $01, $0f, $01, $14, $01, $20, $01, $05, $01, $0e, $01, $0f, $01, $15, $01, $07, $01, $08, $01, $20, $01, $0d, $01, $05, $01, $0d, $01, $0f, $01, $12, $01, $19, $01, $20, $0b ; 20th line (and start of 21st, not enough memory)
    dc.b    $32, $01, $30, $01, $32, $02 ; 21st line (and start of 22nd, 2022)
    dc.b    $ff, $00  
