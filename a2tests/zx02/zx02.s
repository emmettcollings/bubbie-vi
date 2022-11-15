/*
    Processor Information
*/
    processor   6502        ; This informs the assembler that we are using a 6502 processor.

/*
    Memory Map
*/
    org     $1001           ; mem location of user region
    dc.w    stubend
    dc.w    1               ; arbitrary line number for BASIC syntax
    dc.b    $9e, "4353", 0  ; allocate bytes. 4353 = 1101

/*
    Utility Routines
*/
stubend:
    dc.w    0               ; insert null byte

	org	$2000

out_addr = $2200

    incdir      "./"
    include     "zx02-optim.s"  

start:
    jsr     full_decomp

    org     $6700

comp_data:
    incbin  "data.zx02"
    
    jmp     start