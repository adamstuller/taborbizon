module Main exposing (main)

import Alt exposing (basicParser, initRouter, join, topParser)
import Browser
import Form
import Home
import Navbar exposing (viewHeader, viewFooter)


main =
    let
        title =
            "Tábor bizón"
    in
    Home.initPage topParser
        |> join (Form.initPage <| basicParser "form")
        |> initRouter title viewHeader viewFooter
        |> Browser.application
