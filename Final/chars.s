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
    dc.b    $00, $3c, $64, $6a, $6a, $64, $3c, $24  ; AmongusR 3

    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank1 4
    dc.b    $00, $00, $00, $00, $00, $00, $00, $00  ; Blank2 5

    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall1 6
    dc.b    $ff, $8d, $ff, $e7, $ff, $fd, $b1, $ff  ; Wall2 7

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 8
    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy2 9

    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 a
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest2 b

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
    dc.b    $00, $43, $67, $36, $18, $3c, $66, $00  ; Exit 17

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy1 18
    dc.b    $00, $00, $3c, $7e, $7e, $76, $66, $7e  ; Chest1 19

    dc.b    $00, $36, $7d, $7f, $7f, $3e, $1c, $08  ; HeartFull1 1a
    dc.b    $00, $36, $79, $79, $71, $3a, $1c, $08  ; HeartHalf2 1b
    dc.b    $00, $36, $49, $41, $41, $22, $14, $08  ; HeartEmpty3 1c

    dc.b    $bd, $42, $bd, $42, $bd, $42, $bd, $00  ; Border 1d

    dc.b    $00, $3c, $7e, $5a, $7e, $7e, $5a, $42  ; Enemy 1e
    dc.b    $00, $43, $67, $36, $18, $3c, $66, $00  ; Exit 1f


frameBuffer0    .byte   $02, $02, $02, $03, $02, $03, $02, $03, $02
frameBuffer1    .byte   $03, $03, $02, $02, $03, $03, $02, $03, $02
frameBuffer2    .byte   $02, $03, $02, $02, $03, $05, $02, $03, $02
frameBuffer3    .byte   $03, $02, $04, $03, $05, $04, $02, $03, $03
frameBuffer4    .byte   $02, $04, $02, $02, $02, $03, $02, $02, $03
frameBuffer5    .byte   $03, $02, $02, $03, $03, $03, $02, $02, $03
frameBuffer6    .byte   $02, $03, $02, $02, $04, $03, $02, $03, $03
frameBuffer7    .byte   $03, $03, $04, $08, $02, $04, $02, $03, $02
frameBuffer8    .byte   $02, $02, $02, $02, $02, $03, $02, $03, $02