module Home exposing (Model, Msg, init, update, view)

import Asset
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Input as I
import Element.Lazy as L
import Element.Region as R exposing (description)
import Html exposing (Html, a, button, div, h1, h2, img, li, p, table, td, text, th, tr, ul)
import Html.Attributes exposing (class, download, height, href, id, style)
import Html.Events exposing (onClick)
import List
import Ui exposing (color)


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
    , selectedTeam : List Animator
    , documents : List DocumentFile
    }


type Msg
    = NothingYet
    | TeamShiftedRight
    | TeamShiftedLeft


formUrl : String
formUrl =
    "/form"


shiftL : List a -> List a
shiftL list =
    case list of
        [] ->
            []

        x :: [] ->
            [ x ]

        x :: rest ->
            rest ++ [ x ]


shiftR : List a -> List a
shiftR list =
    case List.reverse list of
        [] ->
            []

        x :: [] ->
            [ x ]

        x :: rest ->
            List.reverse <| rest ++ [ x ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        shiftedTeamRight =
            shiftR model.team

        shiftedTeamLeft =
            shiftL model.team
    in
    case msg of
        TeamShiftedLeft ->
            ( { model | selectedTeam = List.take 5 shiftedTeamLeft, team = shiftedTeamLeft }, Cmd.none )

        TeamShiftedRight ->
            ( { model | selectedTeam = List.take 5 shiftedTeamRight, team = shiftedTeamRight }, Cmd.none )

        _ ->
            ( model, Cmd.none )


viewIntro : E.Element Msg
viewIntro =
    E.column
        [ E.width E.fill

        -- , E.explain Debug.todo
        , E.padding 50
        , E.spacingXY 20 20
        , E.htmlAttribute (style "min-height" "calc(100vh)")
        , B.color color.purple
        , B.image <| Asset.filepath Asset.largeIntro
        ]
        [ viewTitle, viewSubtitle, viewSubmitLinkIntro "PRIHLÁSIŤ" ]


viewTitle : E.Element Msg
viewTitle =
    E.row
        [ F.size 150
        , E.centerY
        , E.paddingXY 0 10
        , F.color color.white
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


viewSubmitLinkIntro : String -> E.Element Msg
viewSubmitLinkIntro label =
    E.row
        [ E.centerY
        , E.padding 20
        , F.size 40
        , B.color (E.rgb255 250 105 128)
        , F.color (E.rgb255 255 255 255)
        , Bo.rounded 3
        , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text label } ]


viewAboutUs : List Animator -> E.Element Msg
viewAboutUs model =
    E.column
        [ E.centerX
        , E.spacing 40
        , E.htmlAttribute (id "about")
        , E.width (E.px 1000)
        ]
        [ viewSectionTitle "O NÁS"
        , viewAboutUsText
        , viewAboutUsPhoto
        , viewSubsectionTitle "Animatori"
        , viewTeam model
        ]


viewSectionTitle : String -> E.Element Msg
viewSectionTitle title =
    E.row [ F.size 100, E.centerX ] [ E.text title ]


viewSubsectionTitle : String -> E.Element Msg
viewSubsectionTitle subtitle =
    E.row [ F.size 40, E.centerX ] [ E.text subtitle ]


viewAboutUsText : E.Element Msg
viewAboutUsText =
    let
        t =
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim nisl, sodales vitae purus vitae, porttitor sollicitudin massa. Morbi pharetra mi luctus, tincidunt enim at, placerat augue. Cras eu cursus diam. Nunc laoreet eros risus, at consectetur felis tempus a. Maecenas ipsum nunc, sollicitudin feugiat luctus sed, consectetur ac mauris. Nunc dictum fermentum sem at feugiat. Maecenas malesuada erat sed erat feugiat condimentum. Morbi sed neque at diam lobortis efficitur in sed nisi. Nunc commodo purus at neque placerat, sit amet hendrerit risus placerat. Donec bibendum quam a velit semper, nec porttitor lacus pharetra. Morbi malesuada metus at posuere bibendum. Donec id risus facilisis, feugiat nulla id, fermentum velit. Vestibulum id ultricies ex, et commodo mi. Ut aliquet iaculis dolor a sollicitudin. Aenean rhoncus facilisis augue, nec pharetra sapien iaculis vel. Nam rhoncus convallis dolor vel consectetur. "
    in
    E.row []
        [ E.paragraph [ F.center ]
            [ E.text t
            ]
        ]


viewAboutUsPhoto : E.Element Msg
viewAboutUsPhoto =
    E.row []
        [ E.image
            [ E.width E.fill
            ]
            { src = Asset.filepath Asset.camp, description = "Fotka taborik" }
        ]


viewAnimator : Int -> Animator -> E.Element Msg
viewAnimator l { name, image } =
    E.column [ E.width (E.fillPortion (l + 1)), E.spacingXY 0 20 ]
        [ E.row []
            [ E.image
                [ E.centerX
                , Bo.rounded 100
                , E.clip
                , E.width E.fill
                , E.height E.fill
                ]
                { src = Asset.filepath image, description = name }
            ]
        , E.row [ E.centerX, F.size 16 ]
            [ E.text name ]
        ]


type Alignment
    = L
    | R


viewArrow : Int -> Asset.Asset -> Alignment -> E.Element Msg
viewArrow len arrow align =
    let
        portion =
            (len + 1) // 2

        alignment =
            case align of
                R ->
                    E.alignRight

                L ->
                    E.alignLeft

        description =
            case align of
                R ->
                    "Right arrow"

                L ->
                    "Left arrow"

        clickEventMsg =
            case align of
                R ->
                    TeamShiftedRight

                L ->
                    TeamShiftedLeft
    in
    E.column [ E.width <| E.fillPortion portion ]
        [ E.row [ E.centerY, E.width E.fill, E.height E.fill ]
            [ E.image
                [ alignment
                , E.mouseOver [ B.color <| E.rgb255 222 222 222 ]
                , Ev.onClick clickEventMsg
                ]
                { src = Asset.filepath arrow, description = description }
            ]
        ]


viewTeam : List Animator -> E.Element Msg
viewTeam animators =
    let
        l =
            List.length animators

        animatorList =
            viewArrow l Asset.icons.arrowBack L :: List.map (viewAnimator l) animators ++ [ viewArrow l Asset.icons.arrowForth R ]
    in
    E.row [ E.spacing 10 ] animatorList


viewDocuments : List DocumentFile -> E.Element Msg
viewDocuments documents =
    let
        leftHeaderAttributes =
            [ F.color color.grey
            , F.bold
            , Bo.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
            , Bo.color color.grey
            , E.padding 10
            ]

        rightHeaderAttributes =
            [ F.color (E.rgb255 166 173 180)
            , F.bold
            , Bo.widthEach { bottom = 1, top = 0, left = 0, right = 0 }
            , Bo.color (E.rgb255 166 173 180)
            , E.padding 10
            , F.alignRight
            ]
    in
    E.column
        [ E.centerX
        , E.spacing 40
        , E.width (E.px 1000)
        ]
        [ viewSectionTitle "DOKUMENTY"
        , E.table
            []
            { data = documents
            , columns =
                [ { header = E.el leftHeaderAttributes (E.text "Dokument")
                  , width = E.fillPortion 2
                  , view = \{ name } -> E.el [ E.padding 10, F.light ] (E.text name)
                  }
                , { header = E.el rightHeaderAttributes (E.text "Akcie")
                  , width = E.fillPortion 1
                  , view =
                        \{ file } ->
                            E.download
                                [ E.padding 10
                                , F.alignRight
                                , F.light
                                ]
                                { label = E.text "Stiahnuť"
                                , url = Asset.filepath file
                                }
                  }
                ]
            }
        ]


viewSubmitLinkHome : String -> E.Element Msg
viewSubmitLinkHome label =
    E.row
        [ E.centerX
        , E.padding 20
        , F.size 40
        , B.color (E.rgb255 250 105 128)
        , F.color (E.rgb255 255 255 255)
        , Bo.rounded 3
        , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text label } ]


viewSubmitOption : E.Element Msg
viewSubmitOption =
    E.column
        [ E.centerX
        , E.spacing 40

        -- , E.explain Debug.todo
        , E.width (E.px 1000)
        ]
        [ viewSectionTitle "REGISTRÁCIA"
        , viewSubmitLinkHome "TU"
        ]


viewContactLinks : E.Element Msg
viewContactLinks =
    let
        linkAttributes =
            [ E.alignRight, E.padding 40 ]

        linkImage imageSrc =
            E.image [] { src = Asset.filepath imageSrc, description = "website" }
    in
    E.row
        [ E.spacingXY 0 0, E.width E.fill ]
        [ E.el
            [ F.alignLeft
            , E.padding 40
            , F.color color.grey
            , F.size 40
            ]
            (E.text "tabor@bizon.sk")
        , E.link linkAttributes { url = "/", label = linkImage Asset.icons.web }
        , E.link linkAttributes { url = "https://www.facebook.com/taborbizon", label = linkImage Asset.icons.facebook }
        , E.link linkAttributes { url = "https://www.instagram.com/taborbizon", label = linkImage Asset.icons.instagram }
        ]


viewContacts : E.Element Msg
viewContacts =
    E.column
        [ E.centerX
        , E.width (E.px 1000)
        ]
        [ viewSectionTitle "KONTAKTY", viewContactLinks ]


view : Model -> E.Element Msg
view model =
    E.column
        [ E.width E.fill
        , E.spacing 150

        -- , E.explain Debug.todo
        ]
        [ viewIntro
        , viewAboutUs model.selectedTeam
        , viewDocuments model.documents
        , viewSubmitOption
        , viewContacts
        ]


init : () -> ( Model, Cmd Msg )
init _ =
    let
        team =
            [ -- { name = "Monika Polcová", image = Asset.teamImages.monika }
              { name = "Margareta Mašírová", image = Asset.teamImages.margareta }
            , { name = "Jakob Jan Juhas", image = Asset.teamImages.jakob }
            , { name = "Monika Polcova", image = Asset.teamImages.monika }
            , { name = "Debora Laktisova", image = Asset.teamImages.debora }
            , { name = "Sona Zimmermanova", image = Asset.teamImages.sona }
            , { name = "Vratko Bartos", image = Asset.teamImages.vratko }
            , { name = "Pravko Bartos", image = Asset.teamImages.pravko }
            , { name = "Matus Petras", image = Asset.teamImages.matus }
            , { name = "Simon Kopernicky", image = Asset.teamImages.simon }
            ]
    in
    ( { team = team
      , documents =
            [ { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            , { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            , { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            ]
      , selectedTeam = List.take 5 team
      }
    , Cmd.none
    )
