/*  
 * Draw an entire line of the screen
 */
    processor 6502          ; tell dasm we are writing 6502 asm

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

LOC = $fd
SM = $fb ; location of screen mem in zero page
CHROUT = $ffd2

/* 
 * Our main!
 */
start: 
    lda     #$10            ; line info
    sta     LOC
    lda     #$11            
    sta     LOC + $01

    lda     #$00            ; screen mem
    sta     SM
    lda     #$1e            
    sta     SM + $01

    jsr     drawLine
    rts                     ; return to caller

/*
 * Input: loc in x
 */
drawLine:
    ldy     #$00     

loop:
    lda     #$1110,y        ; load byte
    sta     (SM),y          ; store byte in screen mem
    iny                     ; increment y
    cpy     #$16
    beq     done
    jmp     loop

done:
    jmp     done
    rts

    org     $1110
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30,$30,$30
    dc.b    $30,$30,$30,$30,$30,$30
