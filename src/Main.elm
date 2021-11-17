module Main exposing (main)

import Browser
import Form
import Home
import Navbar exposing (viewNavbar)
import Page
import Router


main =
    Home.initPage "/"
        |> Page.join (Form.initPage "/form")
        |> Router.initRouter "Tábor bizón" viewNavbar
        |> Browser.application
