FRAMEBUF  = $1120
ENEMYCHAR = #$00    ; update this when we know what our enemy tile code is
WALLCHAR  = #$00    ; I forget this too
MOVES     = $fb     ; make sure this address is somewhere suitable for temp use
ENEMYPOS  = $fc
ENEMYPX   = $fd
ENEMYPY   = $fe
RANDOMOUT = $ff     ; I imagine our RNG outputs a bit somewhere, needs to be changed to whatever our thing actually does

; Loop through frame buffer and find any enemies. For each enemy either attempt
; to move closer to player or move randomly
processEnemies:
    ldx     #$51    ; 9x9 = 81 = $51
.loop
    lda     FRAMEBUF,x  ; loop through entire frame buffer and process enemies
    cmp     ENEMYCHAR 
    beq     moveEnemy
.loopControl
    dex
    bne     .loop
    
    rts

; move an enemy either randomly or towards player
moveEnemy:
    stx     ENEMYPOS
    jsr     validMoves          ; init list of valid moves
    lda     MOVES
    beq     .loopControl        ; if we have no valid moves then just do nothing
    jsr     somethingRandom     ; flip coin to decide whether to move randomly
    lda     RANDOMOUT
    and     #$01
    beq     moveRandom

; attempt to move closer to player
moveTowards:
    lda     #$00                ; initialize enemy position variables
    sta     ENEMYPX
    sta     ENEMYPY
findPX:
    lda     ENEMYPOS
    and     #$0f                ; if divisible by 16 we have PX locked in
    beq     findPY 
    dec     ENEMYPOS            ; translate enemy position to camera coords
    inc     ENEMYPX
    jmp     findPX
; find PY coord of enemy
findPY:
    lda     ENEMYPOS
    beq     pickMove
    clc
    sbc     #$10                ; sub 16 to move 1 row
    sta     ENEMYPOS
    inc     ENEMYPY
    jmp     findPY
; Now we have PX,PY we try to move closer
pickMove:
    lda     MOVES
    ldy     PY                  ; try to move vertically first
    cpy     ENEMYPY
    bmi     moveUp              ; if negative then EPY > PY and enemy is below player
moveDown:
    and     #%00000100          ; see if down is valid
    beq     pickHorizontal
    jsr     doDownMove          ; otherwise shift the character
    jmp     .loopControl        ; move has been made, we can quit
moveUp:
    and     #%00001000          ; see if up is valid
    beq     pickHorizontal
    jsr     doUpMove
    jmp     .loopControl
; Try to move horizontally towards player
pickHorizontal:
    ldy     PX
    cpy     ENEMYPX
    bmi     moveLeft            ; if neg then EPX > PX and enemy is right of player
moveRight:
    and     #%00000001          ; see if right is valid
    beq     moveRandom          ; if we got here then our priority moves are invalid so we pick randomly
    jsr     doRightMove
    jmp     .loopControl
moveLeft:
    and     #%00000010          ; see if left is valid
    beq     moveRandom          ; if we got here then our priority moves are invalid so we pick randomly
    jsr     doLeftMove
    jmp     .loopControl

    
; move in a random valid direction
; IMPORTANT this can infinite loop if something goes wrong with our valid move
; checks. Be double sure those are bug free
moveRandom:
    jsr     somethingRandom     ; flip coin for vertical/horizontal
    lda     RANDOMOUT
    and     #$01
    beq     moveVertical
moveHorizontal:
    lda     MOVES
    and     #$03                ; if neither of last 2 bits are set then we have no horizontal moves
    beq     moveVertical
    jsr     somethingRandom     ; flip coin for left/right
    lda     RANDOMOUT
    beq     rMoveLeft
rMoveRight:
    and     #%00000001          ; see if right is valid
    beq     rMoveLeft           ; if not then go left
    jsr     doRightMove         ; otherwise shift the character
    jmp     .loopControl        ; move has been made, we can quit
rMoveLeft:
    and     #%00000010          ; see if left is valid
    beq     rMoveRight          ; if not then go right
    jsr     doLeftMove          ; otherwise shift the character
    jmp     .loopControl        ; move has been made, we can quit
moveVertical:
    lda     MOVES
    and     #$0c                ; if we have no vertical moves then try horizontal
    beq     moveHorizontal
    jsr     somethingRandom     ; flip coin for up/down
    lda     RANDOMOUT
    beq     rMoveUp
rMoveDown:
    and     #%00000100          ; see if down is valid
    beq     rMoveUp             ; if not then go up
    jsr     doDownMove          ; otherwise shift the character
    jmp     .loopControl        ; move has been made, we can quit
rMoveUp:
    and     #%00001000          ; see if up is valid
    beq     rMoveDown           ; if not then go down
    jsr     doUpMove            ; otherwise shift the character
    jmp     .loopControl        ; move has been made, we can quit


; find valid moves for an enemy
; last 4 bits correspond to up/down/left/right
validMoves:
    lda     #%00000000 
    ldy     WALLCHAR
    cpy     FRAMEBUF-9,x
    bne     checkDown
    ora     #%00001000
checkDown:
    cpy     FRAMEBUF+9,x
    bne     checkLeft
    ora     #%00000100
checkLeft:
    cpy     FRAMEBUF-1
    bne     checkRight
    ora     #%00000010
checkRight:
    cpy     FRAMEBUF+1,x
    bne     done
    ora     #%00000001
done:
    sta     MOVES
    rts

; Not sure where these are located or how exactly the shifts are implemented so
; I just included these things as stubs for now
somethingRandom:
    rts
doUpMove:
    rts
doDownMove:
    rts
doLeftMove:
    rts
doRightMove:
    rts
