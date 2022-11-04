/*
    Title Screen Test

    This test will display the title screen to the user.
*/

/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/* 
    Global Definitions
*/
SCRMEM = $1e00
CLRMEM = $9600
size   = $100     ; 256 byte offset to write whole scr/clr mem in one pass
BUBBIESTART = $1e31     ; start of the line that says BUBBIE THE VI
TEAMSTART = $1e5b
YEARSTART = $1e76
BITBUF  = $fb     ; use this as a buffer to hold our bitstream
data = $10ce      ; where our mem is
DATASIZE = $fc    ; keep track of how much data we write here
YEAR = $1090
LASTCHAR = $fe
SUBMEM = $ff

/*
    BASIC stub
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

stubend:    
    dc.w    0               ; insert null byte


/*
    Main Routine
*/
start: 
    jsr     clearScreen             ; clear screen

    lda     #$06            ; set col val to blue for everything
    jsr     colorScreen

    lda     #$80            ; initialize the bit buffer. The 1 in the leftmost
                            ; bit serves as our tracker. When it gets the the
                            ; carry and the buffer is empty (asl shifts 0s in)
                            ; we know we need to fetch the next byte
    sta     BITBUF

    lda     #$0d
    sta     DATASIZE

/*
    Coming up with something that could print out all 3 lines of our title
    screen and reuse lots of code was giving diminishing returns compared 
    to having 1 loop and printing out a bigger piece of data.
 */

initTitleData:
    lda     data    ; first char of title

writeTitle:
    sta     BUBBIESTART
    sta     LASTCHAR
    dec     DATASIZE
    beq     initTeamData

    jsr     getChunk    ; grab 6 byte chunk

    pha                 ; store A on stack
    and     #$20        ; check if bit 6 is set
    beq     .add        ; if not set then we add

    pla
    and     #$1f        ; mask out first 3 bits
    sta     SUBMEM
    lda     LASTCHAR
    sbc     SUBMEM      ; sub in this case
    jmp     .loopControl

.add:
    pla
    and     #$1f
    adc     LASTCHAR

.loopControl
    inc     writeTitle + 1
    jmp     writeTitle

initTeamData:
    lda     #$11
    sta     DATASIZE
    lda     #$0e    ; first char of title

writeTeam:
    sta     TEAMSTART
    sta     LASTCHAR
    dec     DATASIZE
    beq     initYearData

    jsr     getChunk    ; grab 6 byte chunk

    pha                 ; store A on stack
    and     #$20        ; check if bit 6 is set
    beq     .add0        ; if not set then we add

    pla
    and     #$1f        ; mask out first 3 bits
    sta     SUBMEM
    lda     LASTCHAR
    sbc     SUBMEM      ; sub in this case
    jmp     .loopControl0

.add0:
    pla
    and     #$1f
    adc     LASTCHAR

.loopControl0:
    inc     writeTeam + 1
    jmp     writeTeam

initYearData:
    lda     #$04
    sta     DATASIZE
    lda     #$32    ; first char of title

writeYear:
    sta     YEARSTART
    sta     LASTCHAR
    dec     DATASIZE
    beq     wait

    jsr     getChunk    ; grab 6 byte chunk

    pha                 ; store A on stack
    and     #$20        ; check if bit 6 is set
    beq     .add1        ; if not set then we add

    pla
    and     #$1f        ; mask out first 3 bits
    sta     SUBMEM
    lda     LASTCHAR
    sbc     SUBMEM      ; sub in this case
    jmp     .loopControl1

.add1:
    pla
    and     #$1f
    adc     LASTCHAR

.loopControl1:
    inc     writeYear + 1
    jmp     writeYear


wait:
    jmp     wait

    SUBROUTINE
/*
    Gets a single bit from a stream of bits in memory. Uses a buffer to store
    bits from our stream, and we keep track of when we run out of data via a 
    tracking bit. Fairly standard concept as far as assembly goes, I've seen 
    this kind of thing before in computing machinery courses and some security
    applications (see a fair amount of assembly when trying to break things) as
    well.
 */
getBit:
    asl     BITBUF  ; we use a zero page address as a buffer to store our bits
    bne     done    ; if the buffer is empty our tracker has passed through buf
                    ; if this is not the case then we don't have to get data

loadByte:   ; don't technically need a label here but it is more clear this way 
    ldx     data + 1
    inc     loadByte + 1    ; sElF mOdIfYiNg CoDe avoids extra load stores

    stx     BITBUF  ; store our loaded byte into the buffer
    rol     BITBUF  ; inserts our tracker bit at end of buf, loads next bit 

done:
    rts     ; our bit is in C 

    SUBROUTINE
/*
    Loads a 5 bit chunk from our stream to A using our getBit routine.
 */
getChunk:
    lda     #$00    ; clear A
    ldy     #$06    ; our data is organized in 6 bit chunks
.loop:
    jsr     getBit  ; put bit into C
    rol             ; rotate C into A
    dey             ; decrement loop control
    bne     .loop
    rts     ; chunk is in A

    SUBROUTINE
/*
 * Writes whatever is in a to 512 bytes of color mem
 */
colorScreen:
    ldx     #$00    ; only have 1 byte that we can loop on

.loop:      
    sta     CLRMEM,X          ; write in first half
    sta     CLRMEM+size,X     ; write in second half
    inx
    bne     .loop
    rts

/*
    Data
*/
    dc.b    $02, $4f, $20, $07, $8d, $ba, $eb,$89, $ba, $6c
    dc.b    $04, $53, $3a, $24, $11, $ad, $05, $8c, $a7, $20, $20, $c7
    dc.b    $84, $20, $00

clearScreen:
    ldx     #$00    ; only have 1 byte that we can loop on
    lda     #$20    ; clear the screen
clearLoop:
    sta     SCRMEM,X          ; write in first half
    sta     SCRMEM+size,X     ; write in second half
    inx
    bne     clearLoop
    rts
