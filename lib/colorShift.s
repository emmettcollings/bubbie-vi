/*
 * Sets the contents of the border and background color register
 * Input: border and background color bits in a
 */
colorShift:
    sta     $900f   ; location of screen and border color stuff
    rts

