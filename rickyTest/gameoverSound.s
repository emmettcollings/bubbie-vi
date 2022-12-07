; the 'gameover' of the game

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
    dc.b    $9e, "4109", 0              ; allocate bytes. 4109 = 100d

/*
    Utility Routines
*/
stubend:
    dc.w    0                           ; Insert null byte

/* 
    Global Definitions
*/
OSC1 = $900a                            ; The first oscillator.
OSC2 = $900b                            ; The second oscillator.
OSC3 = $900c                            ; The third oscillator.
OSCNS = $900d                           ; The noise source oscillator.
OSCVOL = $900e                          ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start:
    ; set the volume of the oscillators to 1
    lda     #$01
    sta     OSCVOL


/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @Author Justin Parker
    
    @Usage Set $1001 to the number of ~2ms intervals you want to wait for.
*/
timer:           
    dec     $1002           ; Decrement the timer low-bit
    bne     timer           ; If the low-bit is not zero, keep decrementing the low-bit
    dec     $1001           ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit is not zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine