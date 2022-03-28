module Navbar exposing (..)

import Asset exposing (Asset)
import Element as E
import Html exposing (Html, a, div, h1, img, nav, text)
import Html.Attributes exposing (alt, class, href, src, style)
import Router exposing (Navbar)

logo : Html msg
logo =
    img [ src <| Asset.filepath Asset.bizonLogo, alt "logo", class "navbar-logo" ] []

viewNavbar : Navbar msg
viewNavbar routes state onNavbarExpandClicked url =
    let
        device =
            E.classifyDevice state.window

        links =
            div [ class "navbar-links-holder"]
                [ link { linkUrl = "/", label = "Domov" }
                , link { linkUrl = "/form", label = "Registracia" }
                ]

        link { label, linkUrl } =
            a [ href linkUrl, class "navbar-link" ] [ text label ]
    in
    Html.div
        [ class "navbar" ]
        [ logo
        , links
        ]

