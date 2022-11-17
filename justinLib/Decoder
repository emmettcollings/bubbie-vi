/*
    TODO: Document properly
    Size: 
*/
BASE_D = $1661
    org     BASE_D          ; Memory location of new code region

/*
    @ Author:   Justin Parker
    
    ~ Usage:    -> $fb | Byte to be decoded
                <- $fb | high nibble of byte
                <- $fc | low nibble of byte
*/           
decodeByte:
    lda     $fb
    sta     $fc
    lsr
    lsr
    lsr
    lsr
    sta     $fc
    lda     $fb
    and     #%00001111
    sta     $fb
    rts