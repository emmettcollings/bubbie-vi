; Temporary Storage
;   - $fb-fe are to always be considered free temporary space for whatever variable is needed
TEMP1 = $fb
TEMP2 = $fc
TEMP3 = $fd
TEMP4 = $fe

; Temporary Storage
;   - $8d-8f are to always be considered free temporary space for whatever variable is needed
;   - These ZP locations are used by BASIC's RND function, which we do not use.
TEMP5 = $8d
TEMP6 = $8e
TEMP7 = $8f