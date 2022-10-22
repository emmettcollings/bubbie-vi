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
CHROUT = $FFD2              ; kernal character output routine
CLS = $E55f                 ; kernal clear screen routine
COLMEM = $9400              ; Color memory location
SCRMEM = $1E00              ; Screen memory location
;SCREEN_COLOR = $
;BORDER_COLOR = $
;CHARACTER_COLOR = $
;AUX_COLOR = $
pad         .byte   $00, $00, $00 ; Padding so that next byte is on 8 byte boundary
customA     .byte   $18, $24, $42, $7E, $42, $42, $42, $00 ; custom character A (has a mix of screen color, border color, character color, and aux color. honestly, this is the example A from the bible hehe)

/*
    Main Program
*/
    org     $1101           ; mem location of code region
start: 
    jsr     CLS             ; clear screen
    jmp     prepareColor
    rts                     ; return to caller

prepareColor:
    ; in this routine, we will set the screen color, border color, character color, and aux color
    ; once we have set the colors, we will store them in the appropriate memory locations
    ; after that we will call another method to print characters to the screen (which will all require new bit patterns due to the new colors)

    ; remember: little endian, so its read right to left. (so the right most bit is bit 0, and the left most bit is bit 7)

    lda     #%00000000      ; set screen color to black
    sta     $900f           ; store screen color in memory
            ; bits 4-7 are the background color
            ; bits 0-2 are the border color
            ; bit 3 selects inverted or normal mode
    lda     #%00000000      ; set border color to black
    sta     $900e
            ; bits 4-7 are the aux color
            ; bits 0-3 set the volume of all sound channels

/*
 * Sets the contents of the border and background color register
 * Input: border and background color bits in a
 */
printCharacters:
    ; custom character A
    lda     #$fc            
    sta     $9005           ; load custom character set
    jsr     $e55f           ; clear screen
    lda     #$42            ; set a to first character in new character set
    jsr     CHROUT
    jmp     printCharacters

/* 
    Note Section
    -> Apparently the formula to find the current location of color memory is:
        C = 37888 + 4 * (PEAK (36866) AND 128) [This formula is obviously in BASIC]
        So, the formula in 6502 ASM is:
        C = $9400 + 4 * ($9000 AND $80) [Obviously, this isn't right, just noting it down in a basic sense]

    -> We need to enable multi-color mode for the character, which starts at $9600, by adding 8 bits to it.
    -> Horizontal space is halved in multi-color mode. (Makes sense, since we have 2 bits to represent the color)
*/