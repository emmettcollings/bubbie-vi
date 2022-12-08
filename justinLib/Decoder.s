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