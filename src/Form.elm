module Form exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN
-- main =
--     Browser.sandbox { init = init, update = update, view = view }
-- MODEL


type alias Model =
    { childName : String
    , address : String
    , birthDate : String
    , adultName : String
    , adultPhone : String
    , tshirtSize : String
    , specialDiet : String
    , submitted : Bool
    , consented : Bool
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { childName = ""
      , address = ""
      , birthDate = ""
      , adultName = ""
      , adultPhone = ""
      , tshirtSize = ""
      , specialDiet = ""
      , submitted = False
      , consented = False
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChildNameChanged String
    | AddressChanged String
    | BirthDateChanged String
    | AdultNameChanged String
    | AdultPhoneChanged String
    | TshirtSizeChanged String
    | SpecialDietChanged String
    | SubmittedChanged Bool
    | ConsentedChanged Bool


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChildNameChanged childName ->
            { model | childName = childName }

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ label [] [ text "Meno a priezvisko dieťaťa" ]
        , viewInput "text" "" model.childName ChildNameChanged
        , label [] [ text "Meno a priezvisko dieťaťa" ]
        , viewInput "text" "" model.childName ChildNameChanged
        , label [] [ text "Meno a priezvisko dieťaťa" ]
        , viewInput "text" "" model.childName ChildNameChanged
        , label [] [ text "Meno a priezvisko dieťaťa" ]
        , viewInput "text" "" model.childName ChildNameChanged
        , label [] [ text "Meno a priezvisko dieťaťa" ]
        , viewInput "text" "" model.childName ChildNameChanged
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []



-- viewValidation : Model -> Html msg
-- viewValidation model =
--     if model.password == model.passwordAgain then
--         div [ style "color" "green" ] [ text "OK" ]
--     else
--         div [ style "color" "red" ] [ text "Passwords do not match!" ]
