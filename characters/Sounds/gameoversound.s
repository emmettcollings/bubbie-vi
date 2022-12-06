/*
        This test will play main char death tune
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
    lda    #$01
    sta    $900e

    lda    #$D7             ; C
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$E4             ; D
    sta    $900c
            
    stx    $1001
    jsr    timer

    lda    #$9f             ; E
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$E9             ; F
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$ED             ; A
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$F1             ; C#
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$F0             ; C
    sta    $900c
           
    stx    $1001
    jsr    timer



    lda    #$00             ; Rest
    sta    $900c
    ldx    #$63             
    stx    $1001
    jsr    timer

    lda    #$00             ; Off
    sta    $900c

/*    
    @Usage Set $1001 to the number of ~2ms intervals you want to wait for.
*/
timer:           
    dec     $1002           ; Decrement the timer low-bit
    bne     timer           ; If the low-bit is not zero, keep decrementing the low-bit
    dec     $1001           ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit is not zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine

    