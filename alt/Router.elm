module Router exposing (Flags, Navbar, NavbarState, emptyNavbar, initRouter)

import Common exposing (Both)
import Composition exposing (subscribeWith)
import Browser exposing (UrlRequest)
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav
import Either exposing (Either(..))
import Html exposing (Html)
import Html.Attributes exposing (default, height, href, width)
import Json.Decode exposing (Decoder, decodeValue, field, int, map2)
import List.Nonempty as NE exposing (Nonempty)
import Page exposing (ApplicationWithRouter, PageWidgetComposition, Route)
import Url


type alias Flags =
    Json.Decode.Value


flagsDecoder : Decoder Window
flagsDecoder =
    map2 Window
        (field "width" int)
        (field "heiht" int)


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , flags : Flags
    , navbarState : NavbarState
    }


type alias Window =
    { width : Int
    , height : Int
    }


type alias NavbarState =
    { window : Window
    , expanded : Bool
    }


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url.Url
    | WindowSizeChanged Window
    | NavbarExpandedClicked 


type alias Navbar msg =
    Nonempty String -> NavbarState -> msg -> Url.Url -> Html msg


emptyNavbar : Navbar msg
emptyNavbar routingRules navbarState onNavbarExpandClicked url =
    Html.div [] []


pathFromUrl : Nonempty ( path, Route ) -> Url.Url -> path
pathFromUrl rules url =
    let
        default =
            NE.head rules

        matchesUrl u ( p, r ) =
            r == u.path
    in
    NE.filter (matchesUrl url) default rules
        |> NE.head
        |> Tuple.first


routerSubscriptions : Model -> Sub Msg
routerSubscriptions model =
    onResize <|
        \width height ->
            WindowSizeChanged { width = width, height = height }


initRouter :
    String
    -> Navbar Msg
    -> PageWidgetComposition model msg path Flags
    -> ApplicationWithRouter (Both model Model) (Either msg Msg) Flags
initRouter title n w =
    let
        ( select, paths, routes ) =
            w.init

        routingRules =
            NE.zip paths routes

        update =
            \msg ( models, { url, key, flags, navbarState } ) ->
                case msg of
                    Left subMsg ->
                        let
                            ( subModel, subCmd ) =
                                w.update subMsg models
                        in
                        ( ( subModel, Model key url flags navbarState ), Cmd.map Left subCmd )

                    Right routerMsg ->
                        case routerMsg of
                            LinkClicked urlRequest ->
                                case urlRequest of
                                    Browser.Internal internalUrl ->
                                        ( ( models, Model key internalUrl flags navbarState )
                                        , Cmd.map Right <|
                                            Nav.pushUrl key (Url.toString internalUrl)
                                        )

                                    Browser.External href ->
                                        ( ( models, Model key url flags navbarState )
                                        , Cmd.map Right <| Nav.load href
                                        )

                            UrlChanged newUrl ->
                                let
                                    ( subModel, subCmd ) =
                                        select (pathFromUrl routingRules newUrl) flags
                                in
                                ( ( subModel, Model key url flags navbarState )
                                , Cmd.map Left subCmd
                                )

                            WindowSizeChanged window ->
                                let
                                    ( subModel, subCmd ) =
                                        select (pathFromUrl routingRules url) flags

                                    newNavbarState =
                                        { navbarState | window = window }
                                in
                                ( ( subModel, Model key url flags newNavbarState )
                                , Cmd.map Left subCmd
                                )

                            NavbarExpandedClicked ->
                                let
                                    ( subModel, subCmd ) =
                                        select (pathFromUrl routingRules url) flags

                                    newNavbarState =
                                        { navbarState | expanded = not navbarState.expanded }
                                in
                                ( ( subModel, Model key url flags newNavbarState )
                                , Cmd.map Left subCmd
                                )

        init flags url key =
            let
                ( model, cmd ) =
                    select (pathFromUrl routingRules url) flags

                window =
                    case decodeValue flagsDecoder flags of
                        Ok decodedWindow ->
                            decodedWindow

                        Err _ ->
                            { width = 1200, height = 800 }

                navbarState =
                    { window = window, expanded = False }
            in
            ( ( model, Model key url flags navbarState ), Cmd.map Left cmd )

        view =
            \( models, { url, navbarState } ) ->
                { title = title
                , body =
                    [ Html.div []
                        [ Html.map Right <| n routes navbarState NavbarExpandedClicked url
                        , Html.map Left <| w.view models
                        ]
                    ]
                }

        subscriptions =
            subscribeWith w.subscriptions routerSubscriptions
    in
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = \url -> Right <| UrlChanged url
    , onUrlRequest = \urlRequest -> Right <| LinkClicked urlRequest
    }
