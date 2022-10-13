/*
    This test simply plays a really, really, really, annoying sound.
    It actually gave me a mini heart attack when I first ran it... :)
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
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

/*
    Global Definitions
*/
CHROUT = $ffd2              ; The kernel character output routine.
OSC1 = $900a                ; The first oscillator.
OSC2 = $900b                ; The second oscillator.
OSC3 = $900c                ; The third oscillator.
OSCNS = $900d               ; The noise source oscillator.
OSCVOL = $900e              ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)

/*
    Main Routine
*/
    org     $1101           ; mem location of code region
start: 
    ; print 0 to the screen
    lda     #$30            ; this is the VIC-20 symbol for '0'
    jsr     CHROUT          ; call CHROUT

    ; call playTone routine
    jsr     playTone        ; call playTone
    rts                     ; return to caller

/*
    Sound Routine
    - This routine will play a sound on the VIC-20 indefinitely, using the
      three oscillators.
*/
playTone:
    lda     #15
    sta     OSCVOL

    lda     #$ff ; ff causes the oscillator to play the tone, but anything else is just a blip.
    sta     OSC1
    sta     OSC2
    sta     OSC3
    sta     OSCNS

    lda     #0
    sta     OSC1
    sta     OSC2
    sta     OSC3
    sta     OSCNS

    jmp     playTone