module Ui exposing
    ( Window
    , color
    , container
    , containerFormBigDesktop
    , containerFormDesktop
    , containerFormPhone
    , containerFormTablet
    , containerSmall
    )

import Element as E exposing (Color)
import Html.Attributes exposing (style)


type alias Window =
    { width : Int
    , height : Int
    }


color : { grey : Color, white : Color, purple : Color, pink : Color, black : Color, lightGrey : Color, red : Color, lightRed : Color }
color =
    { grey = E.rgb255 166 173 180
    , white = E.rgb255 255 255 255
    , purple = E.rgb255 95 71 127
    , pink = E.rgb255 210 197 227
    , black = E.rgb255 0 0 0
    , lightGrey = E.rgb255 235 235 235
    , red = E.rgb255 250 105 128
    , lightRed = E.rgb255 246 147 163
    }


container : Int -> List (E.Element msg) -> E.Element msg
container width =
    E.column
        [ E.centerX
        , E.spacing 40
        , E.htmlAttribute (style "max-width" "50%")
        , E.height E.fill

        -- , E.explain Debug.todo
        ]


containerSmall : List (E.Element msg) -> E.Element msg
containerSmall =
    E.column
        [ E.centerX
        , E.spacing 20
        , E.htmlAttribute (style "max-width" "80%")

        -- , E.explain Debug.todo
        ]


containerFormBigDesktop : List (E.Element msg) -> E.Element msg
containerFormBigDesktop =
    E.column
        [ E.centerX
        , E.spacing 50
        , E.htmlAttribute (style "max-width" "70%")
        , E.width E.fill

        -- , E.explain Debug.todo
        ]


containerFormDesktop : List (E.Element msg) -> E.Element msg
containerFormDesktop =
    E.column
        [ E.centerX
        , E.spacing 50
        , E.htmlAttribute (style "max-width" "80%")
        , E.width E.fill

        -- , E.explain Debug.todo
        ]


containerFormTablet : List (E.Element msg) -> E.Element msg
containerFormTablet =
    E.column
        [ E.centerX
        , E.spacing 50
        , E.htmlAttribute (style "max-width" "60%")
        , E.width E.fill

        -- , E.explain Debug.todo
        ]


containerFormPhone : List (E.Element msg) -> E.Element msg
containerFormPhone =
    E.column
        [ E.centerX
        , E.spacing 50
        , E.htmlAttribute (style "max-width" "80%")
        , E.width <| E.fill

        -- , E.explain Debug.todo
        ]
