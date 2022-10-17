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
    sta     $1001
    jsr     timer

    lda     #$10
    sta     $1514
    lda     #$10
    sta     $1513

    jsr     charShift_R
    jmp     loop


/*
    A.M.O.G.U.S. Character Right Shift Routine (Advanced Movement Of Graphics Using Shift)
    @ Author: Justin Parker
    
    @ Usage: Set $1501+13, $1501+12 to the low and high address bytes of the character to be shifted respectively
    @ Location specific: Yes

    # Notes: Requires linked characters to be stored at $***0 and $***8 respectively
*/
    org     $1501           ; mem location of new code region
charShift_R:
    lda     $1514           ; Get the high address byte
    sta     $1517           ; Store in the second ROR address byte
    lda     $1513           ; Get the low address byte
    ora     #$08            ; Add 8 to the low address byte (Since the linked character is stored at $***0)
    sta     $1516           ; Store in the first ROR address byte

    ldx     #$07            ; Set x to 7 (The number of bytes needed to ROR)
    clc                     ; Clear the carry flag
csr_loop:
    ror     $fffe,x         ; ff,fe == 1514,1513
    ror     $fffe,x         ; ff,fe == 1517,1516
    dex                     ; Decrement x
    bne     csr_loop        ; Branch if x got underflowed
    rts                     

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author: Justin Parker

    @ Usage: Set $1001 to the number of ~2ms intervals you want to wait for.
    @ Location specific: No

    # Notes: This is a blocking timer. It will not return until the timer has expired.
*/
timer:           
    dec     $1002           ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit hasn't been underflowed, keep decrementing the low-bit
    dec     $1001           ; If the low-bit has been underflowed, decrement the timer high-bit
    bne     timer           ; If the high-bit hasn't been underflowed, keep decrementing the low-bit
    rts                     ; If the high-bit has been underflowed, return from subroutine

