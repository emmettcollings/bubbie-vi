/*
    TODO: Document properly
    Size: 
*/
; BASE_D = $1670
;    org     BASE_D          ; Memory location of new code region

/*
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Byte to be decoded
                <- $fb | high nibble of byte
                <- $fc | low nibble of byte
*/           
decodeByte:
    lda     $fb
    pha
    lsr
    lsr
    lsr
    lsr
    sta     $fb
    pla
    and     #%00001111
    sta     $fc
    rts