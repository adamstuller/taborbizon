module Main exposing (main)

import Asset exposing (Asset)
import Browser exposing (Document)
import Browser.Navigation as Nav
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Input as I
import Element.Lazy as L
import Form
import Home
import Html exposing (Html, h1, img, nav, text)
import Html.Attributes exposing (class, href, style)
import Ui exposing (color)
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
    | FormPage Form.Model
    | NotFound


type Route
    = Home
    | Gallery
    | Form



-- View --


logo : E.Element msg
logo =
    E.el
        [ E.width <| E.px 40
        , Bo.color color.grey
        ]
    <|
        E.image
            [ E.height E.fill
            , E.width E.fill
            ]
            { src = Asset.filepath Asset.bizonLogo, description = "Logo" }


viewNavbar : E.Element Msg
viewNavbar =
    let
        link { label, url } =
            E.link
                [ E.mouseOver [ F.color color.white ]
                ]
                { url = url, label = E.text label }
    in
    E.row
        [ E.width E.fill
        , B.color color.purple
        , F.color color.white
        , F.extraLight
        ]
        [ E.row
            [ E.width E.fill
            , E.padding 20
            , E.spacing 40
            , E.centerX
            ]
            [ logo
            , E.el [ E.alignLeft ] <| E.text "Bizón"
            , E.el [ E.alignRight ] <| link { url = "/", label = "Domov" }
            , E.el [ E.alignRight ] <| link { url = "/form", label = "Registracia" }
            ]
        ]


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                HomePage home ->
                    Home.view home
                        |> E.map GotHomeMessage

                -- FormPage form ->
                --     Form.view form
                --         |> Html.map GotFormMessage
                _ ->
                    E.text "Nothing"
    in
    { title = "Tabor Bizon"
    , body = [ E.layout [ E.inFront viewNavbar ] <| E.column [ E.width E.fill ] [ content ] ]
    }



--- Update --


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMessage Home.Msg
    | GotFormMessage Form.Msg


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

        GotHomeMessage homeMessage ->
            case model.page of
                HomePage home ->
                    toHome model (Home.update homeMessage home)

                _ ->
                    ( model, Cmd.none )



-- _ ->
--     ( model, Cmd.none )


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
