/*
 * Prints out a null terminated string
 *
 * Input: loc of string in y
 */
printString:
    lda     $1100,y     ; for now use absolute indexing but we should try to 
                        ; use the zero page as much as possible to save space
    cmp     #0
    beq     done
    jsr     CHROUT
    iny
    jmp     printString

.done:
    rts

    org     $1100
    dc.b    72,69,76,76,79,0 ; HELLO
