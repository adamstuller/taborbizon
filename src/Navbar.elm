module Navbar exposing (..)

import Asset exposing (Asset)
import Browser exposing (Document)
import Browser.Events exposing (onResize)
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Html exposing (Html, h1, img, nav, text)
import Html.Attributes exposing (class, href, style)
import Router exposing (Navbar, NavbarState)
import Ui exposing (Window, color)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, string)


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


viewNavbarBig : NavbarState -> E.Element msg
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


viewNavbarSmall : NavbarState -> msg -> E.Element msg
viewNavbarSmall state onNavbarExpandClicked =
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
                 , Ev.onMouseDown <| onNavbarExpandClicked
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
                [ E.width <| E.px state.window.width
                , E.htmlAttribute (style "min-height" "calc(100vh)")
                ]
                [ E.column
                    [ E.width <| E.fillPortion 3 -- TODO: Scaling
                    , E.htmlAttribute (style "min-height" "calc(100vh)")
                    , B.color color.white
                    , E.spacing 40
                    , Bo.widthEach { top = 0, bottom = 0, right = 1, left = 0 }
                    , Bo.color color.grey
                    , Bo.shadow { offset = ( 1, 20 ), size = toFloat state.window.width / 8, blur = 60, color = color.lightGrey }
                    ]
                    [ E.el [ E.paddingXY 0 40, E.centerX ] <| logo E.centerX
                    , E.el [ E.paddingXY 40 0 ] <| link { url = "/", label = "Domov" }
                    , E.el [ E.paddingXY 40 0 ] <| link { url = "/form", label = "Registracia" }
                    , contactIcons
                    ]
                , E.column
                    [ E.width <| E.fillPortion 1 -- TODO: Scaling
                    , E.htmlAttribute (style "min-height" "calc(100vh)")
                    , Ev.onClick <| onNavbarExpandClicked
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


viewNavbar : Navbar msg
viewNavbar routes state onNavbarExpandClicked url =
    let
    
        device =
            E.classifyDevice state.window
    in
    Html.div
        [ style "position" "fixed"
        , style "top" "0"
        ]
        [ E.layout [] <|
            case device.class of
                E.Phone ->
                    viewNavbarSmall state onNavbarExpandClicked

                _ ->
                    viewNavbarBig state
        ]
