/*
    TEST INFORMATION GOES HERE!
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

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$93             ; D
    sta    $900c
            
    stx    $100d
    jsr    timer

    lda    #$9f             ; E
    sta    $900c
           
    stx    $100d
    jsr    timer

    lda    #$00             ; Rest
    sta    $900c
    ldx    #$63             
    stx    $100d
    jsr    timer

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$93             ; D
    sta    $900c
            
    stx    $100d
    jsr    timer

    lda    #$9f             ; E
    sta    $900c
           
    stx    $100d
    jsr    timer

    lda    #$00             ; Rest
    sta    $900c
    ldx    #$63             
    stx    $100d
    jsr    timer

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$93             ; D
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$93             ; D
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$9f             ; E
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$9f             ; E
    sta    $900c

    ldx    #$6f             
    stx    $100d
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $100d
    jsr    timer
    lda    #$01       
    sta    $900e

    stx    $100d
    jsr    timer

    lda    #$00             ; Off
    sta    $900c

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @Author Justin Parker
    TODO: Use less total bytes (2+6)
*/
timer:           
    dec     $100e           ; Decrement the timer low-bit
    bne     timer           ; If it's not zero, keep going
    jmp     l100d           ; If it's zero, jump to the timer high-bit
l100d:
    dec     $100d           ; Decrement the timer high-bit
    bne     timer           ; If it's not zero, keep going
    rts                     ; If it's zero, return from subroutine

    