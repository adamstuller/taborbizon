module Main exposing (main)

import Asset
import Browser exposing (Document)
import Browser.Navigation as Nav
import Html exposing (Html, button, div, h1, h2, img, li, nav, p, text, ul)
import Html.Attributes exposing (height, width)
import Url exposing (Url)



-- Model --


type alias Animator =
    { name : String
    , image : Asset.Image
    }


type alias Model =
    { team : List Animator
    , window : Window
    }


type alias Window =
    { width : Int
    , height : Int
    }


type Page
    = HomePage Model
    | NotFound


type Route
    = Home



-- View --


viewHeader : Html Msg
viewHeader =
    nav [] [ h1 [] [ text "Bizon" ] ]


viewIntro : Html Msg
viewIntro =
    div []
        [ h1 [] [ text "Tábor Bizón - 2021" ]
        , h2 [] [ text "Putovanie za Betlehemskou hviezdou" ]
        , button [] [ text "PRIHLÁSIŤ" ]
        ]


viewAboutUs : List Animator -> Html Msg
viewAboutUs team =
    div []
        [ h1 [] [ text "O nás" ]
        , div []
            [ p [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim nisl, sodales vitae purus vitae, porttitor sollicitudin massa. Morbi pharetra mi luctus, tincidunt enim at, placerat augue. Cras eu cursus diam. Nunc laoreet eros risus, at consectetur felis tempus a. Maecenas ipsum nunc, sollicitudin feugiat luctus sed, consectetur ac mauris. Nunc dictum fermentum sem at feugiat. Maecenas malesuada erat sed erat feugiat condimentum. Morbi sed neque at diam lobortis efficitur in sed nisi. Nunc commodo purus at neque placerat, sit amet hendrerit risus placerat. Donec bibendum quam a velit semper, nec porttitor lacus pharetra. Morbi malesuada metus at posuere bibendum. Donec id risus facilisis, feugiat nulla id, fermentum velit. Vestibulum id ultricies ex, et commodo mi. Ut aliquet iaculis dolor a sollicitudin. Aenean rhoncus facilisis augue, nec pharetra sapien iaculis vel. Nam rhoncus convallis dolor vel consectetur. " ]
            ]
        , img [ Asset.src Asset.camp ] []
        , div []
            [ h2 [] [ text "Animátori" ]
            , ul []
                (viewTeam team)
            ]
        ]


viewAnimator : Animator -> Html Msg
viewAnimator { name, image } =
    li [] [ text name, img [ Asset.src image, height 50 ] [] ]


viewTeam : List Animator -> List (Html Msg)
viewTeam animators =
    List.map viewAnimator animators


viewBody : Model -> Html Msg
viewBody model =
    div []
        [ viewIntro
        , viewAboutUs model.team
        ]


view : Model -> Document Msg
view model =
    { title = "Tabor Bizon"
    , body = [ viewHeader, viewBody model ]
    }



--- Update --


type Msg
    = NothingYet
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


init : Window -> Url -> Nav.Key -> ( Model, Cmd Msg )
init window _ _ =
    ( { team =
            [ { name = "Monika Polcová", image = Asset.teamImages.monika }
            , { name = "Margareta Mašírová", image = Asset.teamImages.margareta }
            ]
      , window = window
      }
    , Cmd.none
    )



-- Subscriptions --


subscriptions : Model -> Sub Msg
subscriptions _ =
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
