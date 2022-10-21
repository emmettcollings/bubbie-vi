/*
    Hi.
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

stubend:    
    dc.w    0               ; insert null byte

/* 
    Global Definitions
*/
CLS = $e55f                 ; kernal clear screen routine
COL_MEM = $9400             ; Color memory location

/*
    Main Program
*/
    org     $1101           ; mem location of code region
start: 
    jsr     CLS             ; clear screen
    lda     #$ac            ; funny colors 
    jmp     colorShift
    rts                     ; return to caller

/*
 * Sets the contents of the border and background color register
 * Input: border and background color bits in a
 */
colorShift:
    sta     $900f           ; location of screen and border color stuff
    ; store 191 as hex in accumulator
    lda     #$bf
    sta     $9600
    jmp     colorShift

/* 
    Note Section
    -> Apparently the formula to find the current location of color memory is:
        C = 37888 + 4 * (PEAK (36866) AND 128) [This formula is obviously in BASIC]
        So, the formula in 6502 ASM is:
        C = $9400 + 4 * ($9000 AND $80) [Obviously, this isn't right, just noting it down in a basic sense]
    