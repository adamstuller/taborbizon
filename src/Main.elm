module Main exposing (main)

import Asset exposing (Asset)
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser exposing (Document)
import Browser.Navigation as Nav
import Form
import Home
import Html exposing (Html, h1, img, nav, text)
import Html.Attributes exposing (class, href, style)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)



-- Model --


type alias Model =
    { page : Page
    , key : Nav.Key
    , window : Window
    , navbarState : Navbar.State
    }


type alias Window =
    { width : Int
    , height : Int
    }


type Page
    = HomePage Home.Model
    | FormPage Form.Model
    | NotFound


type Route
    = Home
    | Gallery
    | Form



-- View --


viewHeader : Model -> Html Msg
viewHeader { navbarState } =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.collapseMedium
        -- |> Navbar.fixTop
        -- |> Navbar.container
        |> Navbar.brand [ href "/" ]
            [ img
                [ Asset.src Asset.bizonLogo
                , class "d-inline-block align-top"
                , style "width" "30px"
                ]
                []
            , text " Domov"
            ]
        |> Navbar.items
            [ Navbar.itemLink [ href "/form" ] [ text "Prihlasit" ]
            , Navbar.itemLink [ href "/gallery" ] [ text "Galeria" ]
            ]
        |> Navbar.view navbarState


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                HomePage home ->
                    Home.view home
                        |> Html.map GotHomeMessage

                FormPage form ->
                    Form.view form
                        |> Html.map GotFormMessage

                _ ->
                    text "Nothing"
    in
    { title = "Tabor Bizon"
    , body = [ content ]
    }



--- Update --


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMessage Home.Msg
    | GotFormMessage Form.Msg
    | NavbarMsg Navbar.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.External href ->
                    ( model, Nav.load href )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        ChangedUrl url ->
            updateUrl url model

        GotFormMessage formMessage ->
            case model.page of
                FormPage form ->
                    toForm model (Form.update formMessage form)

                _ ->
                    ( model, Cmd.none )

        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        _ ->
            ( model, Cmd.none )


init : Window -> Url -> Nav.Key -> ( Model, Cmd Msg )
init window url key =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        ( model, _ ) =
            updateUrl url
                { page = NotFound
                , window = window
                , key = key
                , navbarState = navbarState
                }
    in
    ( model, Cmd.none )


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

        Just Form ->
            -- Debug.log "form"
            Form.init ()
                |> toForm model

        Just _ ->
            -- Debug.log "Just"
            ( { model | page = NotFound }, Cmd.none )

        Nothing ->
            -- Debug.log "Nothing"
            ( { model | page = NotFound }, Cmd.none )


toHome : Model -> ( Home.Model, Cmd Home.Msg ) -> ( Model, Cmd Msg )
toHome model ( home, cmd ) =
    ( { model | page = HomePage home }
    , Cmd.map GotHomeMessage cmd
    )


toForm : Model -> ( Form.Model, Cmd Form.Msg ) -> ( Model, Cmd Msg )
toForm model ( form, cmd ) =
    ( { model | page = FormPage form }
    , Cmd.map GotFormMessage cmd
    )



-- Subscriptions --


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg


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
