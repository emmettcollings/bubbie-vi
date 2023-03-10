/*
    Map Data
        - Originally we planned on using PRNG to generate the map, but
          we decided to use a pre-generated map instead. As we didn't have enough
          time to find a proper method to generate a map, that would fit in our
          remaining space. Objects and maps randomly spawn in the map, and the
          player can move around. However, the "walls" are not generated, and
          are instead hardcoded.
*/
Map1   .byte $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
        dc.b $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
        dc.b $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
        dc.b $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33

        dc.b $33, $33,  $22, $22, $32, $22, $22, $22, $22, $22, $22, $22, $22, $22, $32, $33
        dc.b $33, $33,  $22, $22, $32, $22, $22, $22, $22, $22, $23, $23, $33, $22, $32, $22
        dc.b $33, $33,  $22, $32, $22, $32, $23, $22, $32, $32, $23, $22, $33, $32, $33, $32
        dc.b $33, $33,  $23, $23, $22, $32, $33, $32, $32, $32, $23, $22, $22, $22, $32, $22
        dc.b $33, $33,  $32, $22, $32, $32, $22, $22, $22, $22, $23, $23, $33, $23, $32, $33
        dc.b $33, $33,  $22, $22, $22, $22, $22, $22, $22, $22, $23, $23, $32, $23, $22, $22
        dc.b $33, $33,  $33, $33, $33, $33, $22, $23, $23, $22, $23, $23, $32, $33, $22, $22
        dc.b $33, $33,  $22, $22, $22, $23, $33, $23, $23, $22, $23, $22, $32, $22, $22, $33
        dc.b $33, $33,  $22, $22, $22, $22, $22, $23, $23, $22, $33, $32, $32, $32, $22, $33
        dc.b $33, $33,  $33, $33, $33, $22, $22, $23, $33, $22, $22, $32, $32, $32, $22, $33
        dc.b $33, $33,  $22, $22, $23, $22, $32, $23, $23, $33, $32, $22, $32, $32, $22, $33
        dc.b $33, $33,  $22, $22, $22, $22, $32, $22, $22, $22, $22, $32, $32, $32, $22, $33