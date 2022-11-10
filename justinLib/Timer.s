/*
    Size: 9 bytes = 0x09
*/
BASE_T = $1661

    org     BASE_T           ; Memory location of new code region
/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    -> $fc | Number of ~2ms intervals you want to wait for

    & Location specific:    No
    % Alters:   $fb, $fc

    # Notes:    This is a blocking timer. It will not return until the timer has expired.
    9 Bytes
*/
timer:           
    dec     $fb             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fc             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine