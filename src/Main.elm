module Main exposing (main)

import Browser
import Form
import Home
import Navbar exposing (viewNavbar)
import Page
import Router
import Flip exposing (flip)


main =
    Home.initPage "/"
        |> Page.join (Form.initPage "/form")
        |> flip Page.add (Form.initPage "/form")
        |> flip Page.add (Form.initPage "/form")
        |> Router.initRouter "Tábor bizón" viewNavbar
        |> Browser.application



-- technicka dokumentacia - kazda stranka sa stara sama
