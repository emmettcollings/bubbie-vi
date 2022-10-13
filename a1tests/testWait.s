/*
    Testing a way to "wait" for a certain amount of time
    This test will loop the sequence: tone 'C' for 0.5 seconds, then nothing for 0.25 seconds
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
CHROUT = $ffd2              ; kernal character output routine

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

; OSC1 = $900a                ; The first oscillator.
; OSC2 = $900b                ; The second oscillator.
; OSC3 = $900c                ; The third oscillator.
; OSCNS = $900d               ; The noise source oscillator.
; OSCVOL = $900e              ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start:
    lda     #$87             ; C
    sta     $900c

    ldx     #$ff             
    stx     $1001
    jsr     timer
    
    lda     #$00             ; Sound Rest
    sta     $900e
    ldx     #$80             
    stx     $1001
    jsr     timer
    lda     #$01       
    sta     $900e
    jmp     start

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @Author Justin Parker
    
    @Usage Set $1001 to the number of ~2ms intervals you want to wait for.
*/
timer:           
    dec     $1002           ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit is not zero, keep decrementing the low-bit
    dec     $1001           ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit is not zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine

    