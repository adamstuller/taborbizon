module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Home
import Html exposing (Html, h1, nav, text)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)



-- Model --


type alias Model =
    { page : Page
    , key : Nav.Key
    , window : Window
    }


type alias Window =
    { width : Int
    , height : Int
    }


type Page
    = HomePage Home.Model
    | NotFound


type Route
    = Home
    | Gallery
    | Form



-- View --


viewHeader : Html Msg
viewHeader =
    nav [] [ h1 [] [ text "Bizon" ] ]


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                HomePage home ->
                    Home.view home
                        |> Html.map GotHomeMessage

                _ ->
                    text "Nothing"
    in
    { title = "Tabor Bizon"
    , body = [ viewHeader, content ]
    }



--- Update --


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMessage Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


init : Window -> Url -> Nav.Key -> ( Model, Cmd Msg )
init window url key =
    updateUrl url
        { page = NotFound
        , window = window
        , key = key
        }


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Gallery (s "gallery")
        , Parser.map Form (s "form")
        ]


updateUrl : Url -> Model -> ( Model, Cmd Msg )
updateUrl url model =
    case Parser.parse parser url of
        Just Home ->
            Home.init ()
                |> toHome model

        Just _ ->
            ( { model | page = NotFound }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


toHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
toHome model ( home, cmd ) =
    ( { model | page = HomePage home }
    , Cmd.map GotHomeMessage cmd
    )



-- Subscriptions --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program Window Model Msg
main =
    Browser.application
        { init = init
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
