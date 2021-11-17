module Flags exposing (..)

import Json.Decode exposing (Decoder, field, int, map2)
import Ui exposing (Window)


type alias Flags = Json.Decode.Value

flagsDecoder : Decoder Window
flagsDecoder =
    map2 Window
        (field "width" int)
        (field "height" int)
