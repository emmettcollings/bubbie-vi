/*
    Goal of this test is to properly implement multi-color mode.
*/

/*
    Processor Information
*/
    processor   6502            ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001               ; mem location of user region
    dc.w    stubend
    dc.w    1                   ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0      ; allocate bytes. 4353 = 1101

stubend:    
    dc.w    0                   ; insert null byte

/* 
    Global Definitions
*/
; Routines
CHROUT = $FFD2                  ; kernal character output routine
CLS = $E55f                     ; kernal clear screen routine

; Memory Locations
COLMEM = $9400                  ; Color memory location
SCRMEM = $1E00                  ; Screen memory location

; Custom Characters
pad         .byte   $00, $00, $00 ; Padding so that next byte is on 8 byte boundary
; customA     .byte   $18, $24, $42, $7E, $42, $42, $42, $00 ; custom character A (has a mix of screen color, border color, character color, and aux color. honestly, this is the example A from the bible hehe)
; customChar   .byte   $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E ; useless custom character, just for testing purposes
chr_1       .byte   $00, $3c, $26, $56, $56, $26, $3c, $24 ; among us (sussy) [if this renders properly, then multi-color mode isn't working]

/*
    Main Program
*/
    org     $1101               ; mem location of code region
start: 
    jsr     CLS                 ; clear screen
    jsr     enableMultiColor 
    jsr     prepareScreen
    ; jsr     printCharacters     
    jsr     printCharactersWithColors
    rts                         ; return to caller

enableMultiColor:
    rts

prepareScreen:
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
    rts                     ; Ultimately, this isn't needed, as we can just proceed to the next instruction. Just doing it for testing reasons.

printCharacters:
    ; custom character A
    lda     #$fc            
    sta     $9005           ; load custom character set
    jsr     $e55f           ; clear screen
    lda     #$42            ; set a to first character in new character set
    jsr     CHROUT
    rts                     ; this is just for testing purposes, as the next routine is just for testing purposes

printCharactersWithColors:
    lda     #$07
    sta     $0286
    lda     #$30
    jsr     CHROUT

    lda     #$05
    sta     $0286
    lda     #$30
    jsr     CHROUT

    rts                     ; this is just for testing purposes, as the next routine is just for testing purposes




/* 
    Notes

    -> When we've enabled multicolor mode, characters are 4x8 pixels instead of 8x8 pixels. (Halved horizontally, so we can use the mutlicolor mode)
    -> $0x286 is the address for the color that is currently being printed. (We can manipulate this to change the color of each character)
*/