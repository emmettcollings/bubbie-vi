/*
    This is a comment.
*/
    processor 6502 ; This informs DASM we are assembling for the 6502 processor.

/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

stubend:    
    dc.w    0               ; insert null byte

CHROUT  =   $FFD2           ; KERNEL | Output character to channel

; OSC1 = $900a                ; The first oscillator.
; OSC2 = $900b                ; The second oscillator.
; OSC3 = $900c                ; The third oscillator.
; OSCNS = $900d               ; The noise source oscillator.
; OSCVOL = $900e              ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)
    org     $1101           ; mem location assembler assembles to

start:
    lda    #$01
    sta    $900e

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $1001            ; $1001 is being repurposed to be a timer. #$01 ~= 2ms
    jsr    timer
    
    lda    #$93             ; D
    sta    $900c
            
    stx    $1001
    jsr    timer

    lda    #$9f             ; E
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$00             ; Rest
    sta    $900c
    ldx    #$63             
    stx    $1001
    jsr    timer

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$93             ; D
    sta    $900c
            
    stx    $1001
    jsr    timer

    lda    #$9f             ; E
    sta    $900c
           
    stx    $1001
    jsr    timer

    lda    #$00             ; Rest
    sta    $900c
    ldx    #$63             
    stx    $1001
    jsr    timer

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$87             ; C
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$93             ; D
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$93             ; D
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$9f             ; E
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    lda    #$9f             ; E
    sta    $900c

    ldx    #$6f             
    stx    $1001
    jsr    timer
    
    lda    #$00             ; Sound Rest
    sta    $900e
    ldx    #$06             
    stx    $1001
    jsr    timer
    lda    #$01       
    sta    $900e

    stx    $1001
    jsr    timer

    lda    #$00             ; Off
    sta    $900c

/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @Author Justin Parker
    TODO: Use less total bytes (2+6)
*/
timer:           
    dec     $1002           ; Decrement the timer low-bit
    bne     timer           ; If it's not zero, keep going
    jmp     l1001           ; If it's zero, jump to the timer high-bit
l1001:
    dec     $1001           ; Decrement the timer high-bit
    bne     timer           ; If it's not zero, keep going
    rts                     ; If it's zero, return from subroutine

    