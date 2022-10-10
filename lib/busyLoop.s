/*
 * A simple busyloop that might be useful in a program's main loop
 *
 * Input: # of iterations to cycle in a
 */

busyLoop:
    tax     ; transfer input to x

.loop:
    nop             ; waste time
    dex             ; decrement counter
    cpx     #0
    bne     .loop    ; keep looping if we haven't reached the end
    rts


