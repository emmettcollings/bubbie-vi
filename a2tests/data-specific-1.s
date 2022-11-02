/*
    Title Screen Test

    This test will display the title screen to the user.
*/

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
BITBUF  = $00fb     ; use this as a buffer to hold our bitstream
CLS    = $e55f                 ; kernal clear screen routine
SCRMEM = $1e00
BUBBIESTART = $1e31     ; start of the line that says BUBBIE THE VI
TEAMSTART = $1e5b
YEARSTART = $1e76
CLRMEM = $9600
size   = $100     ; 256 byte offset so that we write both halves of mem chunk
                  ; in one loop iteration
data = $100d        ; temp mem location

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Data
*/
l100d   .byte   $90     ; just the letter B in our encoding for now
/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    jsr     CLS             ; clear screen

    lda     #$06            ; set col val to blue for everything
    jsr     colorScreen

    jsr     getChunk        ; get a chunk of mem
    tax                     ; save mem in X
    and     #$10            ; check our indicator bit
    beq     write           ; if 0 then we don't have to modify
    adc     #$10            ; otherwise we need to add 16 for screen code

write:
    stx     BUBBIESTART     ; load our char into screen mem

wait:
    nop
    jmp     wait

    SUBROUTINE
/*
    Gets a single bit from a stream of bits in memory. Uses a buffer to store
    bits from our stream, and we keep track of when we run out of data via a 
    tracking bit.
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
    Loads a 5 bit chunk from our stream to A
 */
getChunk:
    lda     #$00    ; clear A
    ldy     #$05    ; our chars are encoded in 5 bit chunks
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

