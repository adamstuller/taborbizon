module Home exposing (Model, Msg, init, update, view)

import Asset
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Input as I
import Element.Lazy as L
import Element.Region as R
import Html exposing (Html, a, button, div, h1, h2, img, li, p, table, td, text, th, tr, ul)
import Html.Attributes exposing (class, download, height, href, style)
import Html.Events exposing (onClick)


type alias Animator =
    { name : String
    , image : Asset.Asset
    }


type alias DocumentFile =
    { name : String
    , file : Asset.Asset
    }


type alias Model =
    { team : List Animator
    , documents : List DocumentFile
    }


type Msg
    = NothingYet


formUrl : String
formUrl =
    "/form"


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


viewIntro : Html Msg
viewIntro =
    E.layout [] <|
        E.column
            [ E.width E.fill

            -- , E.explain Debug.todo
            , E.padding 50
            , E.spacingXY 20 20
            , E.htmlAttribute (style "min-height" "calc(100vh)")
            , B.color (E.rgb255 95 71 127)
            ]
            [ viewTitle, viewSubtitle, viewSubmitLink ]


viewTitle : E.Element Msg
viewTitle =
    E.row
        [ F.size 150
        , E.centerY
        , E.paddingXY 0 10
        , F.color (E.rgb255 255 255 255)
        , F.bold
        ]
        [ E.text "TÁBOR BIZÓN - 2021" ]


viewSubtitle : E.Element Msg
viewSubtitle =
    E.row
        [ F.size 75
        , E.centerY
        , E.paddingXY 0 20
        , F.color (E.rgb255 210 197 227)
        ]
        [ E.text "Putovanie za betlehemskou hviezdou" ]


viewSubmitLink : E.Element Msg
viewSubmitLink =
    E.row
        [ E.centerY
        , E.padding 20
        , F.size 40
        , B.color (E.rgb255 250 105 128)
        , F.color (E.rgb255 255 255 255)
        , Bo.rounded 3
        , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text "PRIHLÁSIŤ" } ]


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
            , viewTeam team
            ]
        ]


viewAnimator : Animator -> Html Msg
viewAnimator { name, image } =
    li [] [ text name, img [ Asset.src image, height 50 ] [] ]


viewTeam : List Animator -> Html Msg
viewTeam animators =
    ul [] (List.map viewAnimator animators)


viewDocument : DocumentFile -> Html Msg
viewDocument { name, file } =
    tr []
        [ td [] [ text name ]
        , td []
            [ a [ Asset.href file, download name ] [ text "Stiahnuť" ]
            ]
        ]


viewDocuments : List DocumentFile -> Html Msg
viewDocuments documents =
    div []
        [ h1 [] [ text "Dokumenty" ]
        , table []
            [ tr []
                ([ th [] [ text "Dokument" ]
                 , th [] [ text "Akcie" ]
                 ]
                    ++ List.map viewDocument documents
                )
            ]
        ]


viewSubmitOption : Html Msg
viewSubmitOption =
    div []
        [ h2 [] [ text "Prihlásiť sa môžete tu" ]
        , button []
            [ a [ href formUrl ] [ text "PRIHLÁSIŤ" ]
            ]
        ]


viewContacts : Html Msg
viewContacts =
    div []
        [ h2 [] [ text "Kontakty" ]
        , p [] [ text "tabor@bizon.sk" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ viewIntro
        , viewAboutUs model.team

        -- , viewDocuments model.documents
        -- , viewSubmitOption
        -- , viewContacts
        ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( { team =
            [ { name = "Monika Polcová", image = Asset.teamImages.monika }
            , { name = "Margareta Mašírová", image = Asset.teamImages.margareta }
            ]
      , documents =
            [ { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            ]
      }
    , Cmd.none
    )
