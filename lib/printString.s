    processor 6502
    include "globals.s"
/*
 * Input: loc of string in y
 */
printString:
;    lda     (LOC),y         ; load string start location
    lda     $1100,y     ; for now use absolute indexing but we should try to 
                        ; use the zero page as much as possible to save space
    cmp     #0
    beq     done
    jsr     CHROUT
    iny
    jmp     printString

done:
    rts

    org     $1100
    dc.b    72,69,76,76,79,0 ; HELLO


