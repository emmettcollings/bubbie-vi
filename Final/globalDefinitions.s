; Routines
CHROUT = $ffd2                          ; kernal character output routine
SCRMEM = $1e00                          ; Screen memory address
CLRMEM = $9600                          ; Colour memory address 
HALF = $100                             ; Half the screen size

; Sound registers
OSC1 = $900a                            ; The first oscillator. (LOW)
OSC2 = $900b                            ; The second oscillator. (MID)
OSC3 = $900c                            ; The third oscillator. (HIGH)
OSCVOL = $900e                          ; The volume of the oscillators. (bits 0-3 set the volume of all sound channels, bits 4-7 are auxillary color information.)
