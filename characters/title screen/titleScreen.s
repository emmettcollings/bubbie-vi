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
    .byte $20 ,$05 ,$42 ,$02 ,$20 ,$06 ,$42 ,$02
	dc.b $20 ,$03 ,$42 ,$01 ,$20 ,$01 ,$42 ,$01 ,$20 ,$06 ,$42 ,$01 ,$20 ,$01 ,$42 ,$01
	dc.b $20 ,$02 ,$42 ,$01 ,$20 ,$01 ,$42 ,$01 ,$20 ,$06 ,$42 ,$01 ,$20 ,$01 ,$42 ,$01
	dc.b $20 ,$01 ,$43 ,$03
	dc.b $20 ,$01 ,$42 ,$01 ,$20 ,$02 ,$43 ,$03 ,$20 ,$03 ,$43 ,$03 ,$20 ,$02 ,$42 ,$01
	dc.b $20 ,$01 ,$42 ,$01 ,$20 ,$02 ,$42 ,$01 ,$20 ,$02 ,$42 ,$01 ,$20 ,$02 ,$42 ,$01 ,$20 ,$02 ,$42 ,$01
	dc.b $20 ,$01 ,$42 ,$01 ,$20 ,$02 ,$43 ,$03 ,$20 ,$03 ,$43 ,$03 ,$20 ,$02 ,$42 ,$01
	dc.b $20 ,$01 ,$43 ,$03
	dc.b $2F ,$01 ,$20 ,$01 ,$41 ,$01 ,$20 ,$04 ,$4D ,$01 ,$20 ,$01 ,$43 ,$03
	dc.b $42 ,$01 ,$20 ,$05 ,$42 ,$01 ,$20 ,$01 ,$42 ,$01 
	dc.b $4D ,$01 ,$43 ,$03 ,$2F ,$01 ,$20 ,$01 ,$40 ,$01 
	dc.b $20 ,$23 ,$42 ,$01 ,$20 ,$23 ,$42 ,$01 ,$20 ,$23 ,$42 ,$01 ,$20 ,$23 ,$42 ,$01
	dc.b $2F ,$01 ,$52 ,$03 ,$42 ,$01 ,$20 ,$29 ,$42 ,$01 ,$52 ,$03 ,$4D ,$01  