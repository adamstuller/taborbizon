module Ui exposing (color)

import Element as E


color : { grey : E.Color, white : E.Color, purple : E.Color, pink : E.Color, black : E.Color, lightGrey : E.Color }
color =
    { grey = E.rgb255 166 173 180
    , white = E.rgb255 255 255 255
    , purple = E.rgb255 95 71 127
    , pink = E.rgb255 210 197 227
    , black = E.rgb255 0 0 0
    , lightGrey = E.rgb255 235 235 235
    }
