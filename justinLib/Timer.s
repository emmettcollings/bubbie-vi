/*
    The best goddamn timer that's ever existed on pure American hardware god damnit
    @ Author:   Justin Parker

    ~ Usage:    -> $fd | Number of ~2ms intervals you want to wait for

    & Location specific:    No
    % Alters:   $fc, $fd

    # Notes:    This is a blocking timer. It will not return until the timer has expired.
    9 Bytes
*/
timer:           
    dec     $fc             ; Decrement the timer low-bit (is not initially set, so timing may vary by up to 1 cycle)
    bne     timer           ; If the low-bit isn't zero, keep decrementing the low-bit
    dec     $fd             ; If the low-bit is zero, decrement the timer high-bit
    bne     timer           ; If the high-bit isn't zero, keep decrementing the low-bit
    rts                     ; If the high-bit is zero, return from subroutine