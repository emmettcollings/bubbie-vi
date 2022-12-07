/*
    Data
*/
    org     $1010   
    ; Blank-2
    ; Wall-3
    ; Enemy-4
    ; Chest-5    
    ; SAME:  2a
    ; COMBO: 4a+2b-2

    dc.b    $00, $3c, $26, $56, $56, $26, $3c, $24  ; AmongusL 2
    dc.b    $00, $18, $7e, $18, $18, $18, $3c, $7e  ; Tombstone 3

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1 4
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2 5

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 6
    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall2 7

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 8
    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy2 9

    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 a || X
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest2 b || X

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B c
    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall2B d

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B e
    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 f

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1B 10
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 11

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 12
    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 13

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 14
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 15

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank 16
    dc.b    $a5, $bd, $a5, $bd, $a5, $bd, $a5, $ff  ; Exit 17

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 18
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 19

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 1a
    dc.b    $a5, $bd, $a5, $bd, $a5, $bd, $a5, $ff  ; Exit 1b

    dc.b    $00, $ff, $ff, $ff, $ff, $ff, $ff, $00  ; TimerBar 2c
    dc.b    $00, $7e, $7e, $7e, $7e, $7e, $7e, $00  ; TimerBar 2d

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy 1e
    dc.b    $a5, $bd, $a5, $bd, $a5, $bd, $a5, $ff  ; Exit 1f

    dc.b    $00, $36, $49, $41, $41, $22, $14, $08  ; HeartEmpty3 20
    dc.b    $00, $36, $79, $79, $71, $3a, $1c, $08  ; HeartHalf2 21
    dc.b    $00, $36, $7d, $7f, $7f, $3e, $1c, $08  ; HeartFull1 22
    dc.b    $bd, $42, $bd, $42, $bd, $42, $bd, $00  ; Border 23
    dc.b    $00, $0c, $0e, $1b, $3e, $fc, $78, $10  ; Bubbies 24
    

; 1f -> 1100
frameBuffer0    .byte   $00, $00, $00, $00, $00, $00, $00, $00, $00
frameBuffer1    .byte   $00, $00, $00 ,$00, $00, $00, $00, $00, $00
frameBuffer2    .byte   $00, $00, $00, $00, $00, $04, $00, $00, $00
frameBuffer3    .byte   $00, $00, $00, $04, $00, $00, $00, $00, $00
frameBuffer4    .byte   $00, $00, $00, $00, $00, $00, $00, $00, $00
frameBuffer5    .byte   $00, $00, $00, $00, $00, $00, $00, $00, $00
frameBuffer6    .byte   $00, $00, $04, $00, $00, $00, $04, $00, $00
frameBuffer7    .byte   $00, $00, $00, $04, $00, $00, $00, $00, $00
frameBuffer8    .byte   $00, $00, $00, $00, $00, $00, $00, $00, $00