module Main exposing (main)

import Asset exposing (Asset)
import Browser exposing (Document)
import Browser.Events exposing (onResize)
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
import Ui exposing (Window, color)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)



-- Model --


type alias NavbarState =
    { expanded : Bool
    }


type alias Model =
    { page : Page
    , key : Nav.Key
    , window : Window
    , device : E.Device
    , navbarState : NavbarState
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


logo : E.Attribute msg -> E.Element msg
logo align =
    E.el
        [ E.width <| E.px 30
        , Bo.color color.grey
        , align
        ]
    <|
        E.image
            [ E.height E.fill
            , E.width E.fill
            ]
            { src = Asset.filepath Asset.bizonLogo, description = "Logo" }


viewNavbarBig : NavbarState -> E.Element Msg
viewNavbarBig _ =
    let
        link { label, url } =
            E.link
                [ E.mouseOver [ F.color color.purple ]
                ]
                { url = url, label = E.text label }
    in
    E.row
        [ E.width E.fill
        , B.color color.white
        , F.color color.grey
        , F.extraLight
        , Bo.widthEach { top = 0, bottom = 1, right = 0, left = 0 }
        , Bo.color color.purple
        ]
        [ E.row
            [ E.width E.fill
            , E.paddingXY 20 10
            , E.spacing 40
            , E.centerX
            ]
            [ logo E.alignLeft
            , E.el [ E.alignLeft ] <| E.text "Bizón"
            , E.el [ E.alignRight ] <| link { url = "/", label = "Domov" }
            , E.el [ E.alignRight ] <| link { url = "/form", label = "Registracia" }
            ]
        ]


viewNavbarSmall : NavbarState -> Window -> E.Element Msg
viewNavbarSmall state window =
    let
        link { label, url } =
            E.link
                [ E.mouseOver [ F.color color.purple ]
                ]
                { url = url, label = E.text label }

        menuIcon =
            E.image
                ([ E.alignLeft
                 , E.centerY
                 , E.paddingXY 20 20
                 , Ev.onMouseDown <| NavbarExpandClicked True
                 ]
                    ++ expandedMenuPlaced
                )
                { src = Asset.filepath Asset.icons.menu, description = "menu" }

        linkAttributes =
            []

        linkImage imageSrc =
            E.image [] { src = Asset.filepath imageSrc, description = "website" }

        contactIcons =
            E.column
                [ E.width E.fill
                , E.htmlAttribute (style "min-height" "calc(20vh)")
                , B.color color.grey
                , E.alignBottom
                ]
                [ E.row [ F.color color.white, E.paddingXY 40 10, E.centerY, E.centerX ] [ E.text "tabor@bizon.sk" ]
                , E.row [ E.paddingXY 40 10, E.centerY, E.centerX, E.spacingXY 10 0 ]
                    [ E.link linkAttributes { url = "/", label = linkImage Asset.icons.webWhite }
                    , E.link linkAttributes { url = "https://www.facebook.com/taborbizon", label = linkImage Asset.icons.facebookWhite }
                    , E.link linkAttributes { url = "https://www.instagram.com/taborbizon", label = linkImage Asset.icons.instagramWhite }
                    ]
                ]

        expandedMenu =
            E.row
                [ E.width <| E.px window.width
                , E.htmlAttribute (style "min-height" "calc(100vh)")
                ]
                [ E.column
                    [ E.width <| E.fillPortion 3 -- TODO: Scaling
                    , E.htmlAttribute (style "min-height" "calc(100vh)")
                    , B.color color.white
                    , E.spacing 40
                    , Bo.widthEach { top = 0, bottom = 0, right = 1, left = 0 }
                    , Bo.color color.grey
                    , Bo.shadow { offset = ( 1, 20 ), size = toFloat window.width / 8, blur = 60, color = color.lightGrey }
                    ]
                    [ E.el [ E.paddingXY 0 40, E.centerX ] <| logo E.centerX
                    , E.el [ E.paddingXY 40 0 ] <| link { url = "/", label = "Domov" }
                    , E.el [ E.paddingXY 40 0 ] <| link { url = "/form", label = "Registracia" }
                    , contactIcons
                    ]
                , E.column
                    [ E.width <| E.fillPortion 1 -- TODO: Scaling
                    , E.htmlAttribute (style "min-height" "calc(100vh)")
                    , Ev.onClick <| NavbarExpandClicked False
                    ]
                    []
                ]

        expandedMenuPlaced =
            if state.expanded then
                [ E.inFront <| E.column [] [ expandedMenu ] ]

            else
                []
    in
    E.row
        [ E.width E.fill
        , B.color color.white
        , F.color color.grey
        , F.extraLight
        , Bo.widthEach { top = 0, bottom = 1, right = 0, left = 0 }
        , Bo.color color.purple
        , E.paddingXY 20 10
        , E.spacing 40

        -- , E.explain Debug.todo
        , E.inFront <| E.column [] [ menuIcon ]
        ]
        [ logo E.centerX
        ]


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                HomePage home ->
                    Home.view home model.window model.device
                        |> E.map GotHomeMessage

                FormPage form ->
                    Form.view form model.window model.device
                        |> E.map GotFormMessage

                _ ->
                    E.text "Nothing"

        navbar =
            case model.device.class of
                E.Phone ->
                    viewNavbarSmall model.navbarState model.window

                _ ->
                    viewNavbarBig model.navbarState
    in
    { title = "Tabor Bizon"
    , body =
        [ E.layout
            [ E.inFront navbar
            ]
          <|
            E.column [ E.width E.fill ] [ content ]
        ]
    }



--- Update --


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | GotHomeMessage Home.Msg
    | GotFormMessage Form.Msg
    | WindowSizeChanged Window
    | NavbarExpandClicked Bool


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

        WindowSizeChanged window ->
            ( { model | window = window, device = E.classifyDevice window }, Cmd.none )

        NavbarExpandClicked expanded ->
            ( { model | navbarState = { expanded = expanded } }, Cmd.none )



-- _ ->
--     ( model, Cmd.none )


init : Window -> Url -> Nav.Key -> ( Model, Cmd Msg )
init window url key =
    updateUrl url
        { page = NotFound
        , window = window
        , key = key
        , device = E.classifyDevice window
        , navbarState = { expanded = False }
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
    onResize <|
        \width height ->
            WindowSizeChanged { width = width, height = height }


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
