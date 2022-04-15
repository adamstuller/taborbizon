module Main exposing (main)

import Alt exposing (basicParser, emptyFooter, initRouter, join, topParser)
import Browser
import Form
import Home
import Navbar exposing (viewHeader)


main =
    let
        title =
            "Tábor bizón"
    in
    Home.initPage topParser
        |> join (Form.initPage <| basicParser "form")
        |> initRouter title viewHeader emptyFooter
        |> Browser.application
