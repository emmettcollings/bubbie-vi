; ENEMYCHAR = #$04    ; Enemy char is $04
; WALLCHAR  = #$03    ; Wall char is $03
MOVES     = TEMP1     ; make sure this address is somewhere suitable for temp use
ENEMYPOS  = TEMP2
ENEMYPX   = TEMP3
ENEMYPY   = TEMP4

; Loop through frame buffer and find any enemies. For each enemy either attempt
; to move closer to player or move randomly
processEnemies:
    ldx     #$51    ; 9x9 = 81 = $51
processEnemyLoop:
    lda     frameBuffer0,x  ; loop through entire frame buffer and process enemies
    cmp     #$04 
    beq     moveEnemy
processEnemyContinue:
    dex
    bne     processEnemyLoop
    
    rts

; move an enemy either randomly or towards player
moveEnemy:
    stx     ENEMYPOS
    jsr     validMoves          ; init list of valid moves
    lda     MOVES
    beq     processEnemyContinue        ; if we have no valid moves then just do nothing
    jsr     somethingRandom     ; flip coin to decide whether to move randomly
    lda     randomData
    and     #%11000000
    beq     processEnemyContinue ; 1/8 chance to skip turn
    lda     randomData
    and     #%00000001          ; 1/4 chance to move towards player
    beq     moveRandom

; attempt to move closer to player
moveTowards:
    lda     #$00                ; initialize enemy position variables
    sta     ENEMYPY
; find PY coord of enemy
    lda     ENEMYPOS
findPY:
    sec
    sbc     #$09                ; sub 16 to move 1 row
    bmi     findPX
    inc     ENEMYPY
    jmp     findPY
findPX:
    clc
    adc     #$09                ; add 16 to move 1 row
    sta     ENEMYPX

; Now we have PX,PY we try to move closer
pickMove:
    lda     MOVES
    ldy     #$04
    cpy     ENEMYPY
    beq     pickHorizontal
    bmi     moveEnemyUp              ; if negative then EPY > PY and enemy is below player
moveEnemyDown:
    and     #%00000100          ; see if down is valid
    beq     pickHorizontal
    jsr     doDownMove          ; otherwise shift the character
    jmp     processEnemyContinue        ; move has been made, we can quit
moveEnemyUp:
    and     #%00001000          ; see if up is valid
    beq     pickHorizontal
    jsr     doUpMove
    jmp     processEnemyContinue
; Try to move horizontally towards player
pickHorizontal:
    ldy     #$04
    cpy     ENEMYPX
    bmi     moveEnemyLeft            ; if neg then EPX > PX and enemy is right of player
moveEnemyRight:
    and     #%00000001          ; see if right is valid
    beq     moveRandom          ; if we got here then our priority moves are invalid so we pick randomly
    jsr     doRightMove
    jmp     processEnemyContinue
moveEnemyLeft:
    and     #%00000010          ; see if left is valid
    beq     moveRandom          ; if we got here then our priority moves are invalid so we pick randomly
    jsr     doLeftMove
    jmp     processEnemyContinue

    
; move in a random valid direction
; IMPORTANT this can infinite loop if something goes wrong with our valid move
; checks. Be double sure those are bug free
moveRandom:
    jsr     somethingRandom     ; flip coin for vertical/horizontal
    lda     randomData
    and     #%00000010
    beq     moveVertical
moveHorizontal:
    lda     MOVES
    and     #$03                ; if neither of last 2 bits are set then we have no horizontal moves
    beq     moveVertical
    jsr     somethingRandom     ; flip coin for left/right
    lda     randomData
    and     #%00000100
    beq     rmoveEnemyLeft
rmoveEnemyRight:
    lda     MOVES
    and     #%00000001          ; see if right is valid
    beq     rmoveEnemyLeft           ; if not then go left
    jsr     doRightMove         ; otherwise shift the character
    jmp     processEnemyContinue        ; move has been made, we can quit
rmoveEnemyLeft:
    lda     MOVES
    and     #%00000010          ; see if left is valid
    beq     rmoveEnemyRight          ; if not then go right
    jsr     doLeftMove          ; otherwise shift the character
    jmp     processEnemyContinue        ; move has been made, we can quit
moveVertical:
    lda     MOVES
    and     #$0c                ; if we have no vertical moves then try horizontal
    beq     moveHorizontal
    jsr     somethingRandom     ; flip coin for up/down
    lda     randomData
    and     #%00000100
    beq     rmoveEnemyUp
rmoveEnemyDown:
    lda     MOVES
    and     #%00000100          ; see if down is valid
    beq     rmoveEnemyUp             ; if not then go up
    jsr     doDownMove          ; otherwise shift the character
    jmp     processEnemyContinue        ; move has been made, we can quit
rmoveEnemyUp:
    lda     MOVES
    and     #%00001000          ; see if up is valid
    beq     rmoveEnemyDown           ; if not then go down
    jsr     doUpMove            ; otherwise shift the character
    jmp     processEnemyContinue        ; move has been made, we can quit


; find valid moves for an enemy
; last 4 bits correspond to up/down/left/right
validMoves:
    lda     #%00000000 
    pha;J;
    lda     frameBuffer0-9,x;J;
    cmp     #$02;J;
    bne     checkDown
    pla;J;
    ora     #%00001000
    pha
checkDown:
    lda     frameBuffer0+9,x
    cmp     #$02
    bne     checkLeft
    pla
    ora     #%00000100
    pha
checkLeft:
    lda     frameBuffer0-1,x
    cmp     #$02
    bne     checkRight
    pla
    ora     #%00000010
    pha
checkRight:
    lda     frameBuffer0+1,x
    cmp     #$02
    bne     done
    pla
    ora     #%00000001
    pha
done:
    pla
    sta     MOVES
    rts

; Not sure where these are located or how exactly the shifts are implemented so
; I just included these things as stubs for now
somethingRandom:
    lda     randomData
    eor     JIFCLOCKM
    eor     JIFCLOCKL
    rol
    rol
    rol
    rol
    sta     randomData
    rts
doUpMove:
    txa
    tay

    ldx     ENEMYPOS
    lda     #$02
    sta     frameBuffer0,x
    lda     #$04
    sta     frameBuffer0-$9,x

    tya
    tax

    rts
doDownMove:
    txa
    tay

    ldx     ENEMYPOS
    lda     #$02
    sta     frameBuffer0,x
    lda     #$04
    sta     frameBuffer0+$9,x
    
    tya
    tax

    rts
doLeftMove:
    txa
    tay

    ldx     ENEMYPOS
    lda     #$02
    sta     frameBuffer0,x
    lda     #$04
    sta     frameBuffer0-$1,x
    
    tya
    tax

    rts
doRightMove:
    txa
    tay

    ldx     ENEMYPOS
    lda     #$02
    sta     frameBuffer0,x
    lda     #$04
    sta     frameBuffer0+$1,x
    
    tya
    tax

    rts


MoveEnemies:
    ldx     #$3d

    lda     #$07
    sta     TEMP5
ME_Init:
    lda     #$07
    sta     TEMP6
ME_Loop:
    lda     frameBuffer1,x
    cmp     #$04
    bne     ME_Store

    lda     #$02
    sta     frameBuffer1,x

    lda     #$06
    ldy     TEMP7
    cpy     #$00
    bne     ME_Right
    sta     frameBuffer1-$1,x
    jmp     ME_Store
ME_Right:
    cpy     #$01
    bne     ME_Down
    sta     frameBuffer1+$1,x
    jmp     ME_Store
ME_Down:
    cpy     #$02
    bne     ME_Up
    sta     frameBuffer1+$9,x
    jmp     ME_Store
ME_Up:
    sta     frameBuffer1-$9,x
ME_Store:
    dex
    dec     TEMP6
    bne     ME_Loop

    dex
    dex
    dec     TEMP5
    bne     ME_Init

    ldx     #$50
ME_Revert:
    lda     frameBuffer0,x
    cmp     #$06
    bne     ME_Revert2
    lda     #$04
    sta     frameBuffer0,x
ME_Revert2:
    dex
    bpl     ME_Revert

    rts
