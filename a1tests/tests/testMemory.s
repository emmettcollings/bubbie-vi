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

; Store "!NITSUJ" in memory to be read backwards
l100d   .byte   $21, $4e, $49, $54, $53, $55, $4a

start: 
    jsr     $e55f           ; clear screen
    ldx     #$07            ; set x to 7 (7 characters in "!NITSUJ")
name:
    lda     l100d-1,x       ; reference name of memory <=> reference start of memory
    dex
    jsr     CHROUT
    bne     name
    rts
    end                     ; end of assembly code



    


