/*
    Title Screen Test

    This test will display the title screen to the user.
*/

/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

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
    Global Definitions
*/
CLS    = $e55f                 ; kernal clear screen routine
SCRMEM = $1e00
CLRMEM = $9600
size   = $100     ; 256 byte offset to write whole scr/clr mem in one pass
BUBBIESTART = $1e31     ; start of the line that says BUBBIE THE VI
TEAMSTART = $1e5b
YEARSTART = $1e76
BITBUF  = $fb     ; use this as a buffer to hold our bitstream
data = $107d      ; where our mem is
DATASIZE = $fc    ; keep track of how much data we write here
YEAR = $1090


/*
    Main Routine
*/
start: 
    jsr     CLS             ; clear screen

    lda     #$06            ; set col val to blue for everything
    jsr     colorScreen

    lda     #$80            ; initialize the bit buffer. The 1 in the leftmost
                            ; bit serves as our tracker. When it gets the the
                            ; carry and the buffer is empty (asl shifts 0s in)
                            ; we know we need to fetch the next byte
    sta     BITBUF

    lda     #$02
    sta     DATASIZE
writeTitle:
    lda     data    ; first char of title
    sta     BUBBIESTART

.loop:
    jsr     getChunk    ; grab 6 byte chunk
    tax                 ; save in X for now
    and     #$30        ; check for bit 6
    beq     .sub        ; bit 6 is not set so we sub

.add:
    txa     ; reload X into A
    ora     #$1f        ; keep last 5 bits
    jmp     .write

.sub:

.write:
    

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
    ldx     data
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
    dc.b    $02, $cc    ; B, then + 11001100 which says add 10011 (13) to prev 

