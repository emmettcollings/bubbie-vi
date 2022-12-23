; Temporary Storage
;   - $fb-fe are to always be considered free temporary space for whatever variable is needed.
TEMP1 = $fb
TEMP2 = $fc
TEMP3 = $fd
TEMP4 = $fe

;   - $8b-8e are to always be considered free temporary space for whatever variable is needed.
;   - These ZP locations are used by BASIC's RND function, which we do not use within our game.
TEMP5 = $8b
TEMP6 = $8c
TEMP7 = $8d
TEMP8 = $8e

; System clock variables
JIFCLOCKM = $a1
JIFCLOCKL = $a2