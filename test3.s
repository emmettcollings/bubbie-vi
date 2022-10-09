/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Global Definitions
*/
CHROUT = $ffd2              ; The kernel character output routine.

/*
    Sound Routine
*/
playTone:
    lda     #$0f
    sta     $900a           ; Set the frequency of oscillator 1.
    lda     #$0f            
    sta     $900d           ; Set the frequency of the noise sourc.
    lda     #$0f    
    sta     $900e           ; Set the volume to the maximum.
    jsr     playTone

/*
    Main Routine
*/
start: 
    ; print 0 to the screen
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHROUT          ; call CHROUT

    ; call playTone routine
    jsr     playTone        ; call playTone
    rts                     ; return to caller