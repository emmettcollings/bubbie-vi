/*
    This is a comment.
*/
    processor 6502 ; This informs DASM we are assembling for the 6502 processor.

/*
    Thanks to Emmett for the following code, as I needed some test code to ensure everything was working!
 */

/* 
 * Write some BASIC code into memory that will jump to our assembly. User
 * written BASIC gets stored at $1001 so that's where we begin
 */
    org     $1001           ; mem location assembler assembles to
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4109", 0  ; allocate bytes. 4109 = $100d

stubend:    
    dc.w    0               ; insert null byte

;CHRIN   =   $FFCF           ; KERNEL | Input character from channel
CHROUT  =   $FFD2           ; KERNEL | Output character to channel
;RDTIM   =   $FFDE           ; KERNEL | Read system clock (60th of a second)


; "PRESS ANY KEY" [broken cus im shit at this assembler and dont know how to store mem at specific address :(]
l100d   .byte   $50, $52, $45, $53, $53, $20, $41, $4E, $59, $20, $4B, $45, $59

start: 
    jsr     $e55f           ; clear screen
    ldx     #$00
name:
    lda     l100d-1,x       ; reference name of memory <=> reference start of memory
    inx
    jsr     CHROUT
    cpx     #$00
    bne     name

nopress:
    lda     $cb
    cmp     #$40
    bne     nopress
press:
    lda     $cb
    cmp     #$40
    beq     press
    lda     #$58
    jsr     CHROUT
    rts
    end                     ; end of assembly code



    


