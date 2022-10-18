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
    lda     #$42            ; set a to first character in new character set
    jsr     CHROUT
    lda     #$43            ; set a to second character in new character set
    jsr     CHROUT

loop:
    lda     #$4f
    sta     $fc
    jsr     timer

    lda     #$01
    sta     $fc
    lda     #$7e
    sta     $fb

    jsr     charShift_H
    jmp     loop


/*
    A.M.O.G.U.S. Character Horizontal Shift Routine (Advanced Movement Of Graphics Using Shift)
    @ Author:   Justin Parker
    
    @ Usage:    $fb     | Direction to shift character (3e = <-, 7e = ->)
                $fc     | Identifier of first linked character to shift ($1**0)
        
    @ Location specific:    Yes

    # Notes:    Requires linked characters to be stored at $1**0 and $1**8 respectively
    56 Bytes
*/
    org     $1501           ; Memory location of new code region
charShift_H:
    ldx     #$03            ; Initialize counter while also setting up for ror, since high nibble = 0 is all that matters
    stx     $fd             ; Store value in $fd for ror
    lda     $fc             ; Load identifier of first character to shift

    sec                     ; Set carry flag to ensure high nibble is 1
    ror     $fc             ; Shift high nibble of identifier
cS_P:                       ; Perform shift 3 times     
    ror     $fd             ; --^
    lsr     $fc             ; --^
    dex                     ; --^
    bne     cS_P            ; --*
    ror     $fd             ; Shift low nibble of identifier

    lda     $fd             ; Load low byte of the address
    sta     $1531           ; Store value in $1501 + 30 [SMC]
    sta     $1534           ; Store value in $1501 + 33 [SMC]

    lda     $fc             ; Load high byte of the address
    sta     $1530           ; Store value in $1501 + 2f [SMC]
    ora     #$08            ; Add 8 to the low address byte (Since the linked character is stored at $***0)
    sta     $1533           ; Store value in $1501 + 32 [SMC]

    lda     $fb             ; Get the instruction byte
    sta     $152f           ; Store in the instruction byte for the first ROx [SMC]
    sta     $1532           ; Store in the instruction byte for the second ROx [SMC]

    ldx     #$07            ; Set x to 7 (The number of bytes needed to ROx)
cS_L:
    ror     $1234,x         ; Code to be modified (1/2)
    rol     $8765,x         ; Code to be modified (2/2)
    dex                     ; Decrement x
    bne     cS_L            ; Branch if x got underflowed
    rts                     

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    $fc | Number of ~2ms intervals you want to wait for.

    & Location specific:    No

    # Notes: This is a blocking timer. It will not return until the timer has expired.
    9 Bytes
*/
    org     $1551           ; Memory location of new code region
timer:           
    dec     $fb             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fc             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine

