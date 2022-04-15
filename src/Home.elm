module Home exposing (initPage)

import Asset
import Browser.Events exposing (onResize)
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Lazy as L
import Element.Region as R exposing (description)
import Html exposing (Html, a, button, div, h1, h2, li, p, table, td, text, th, tr, ul)
import Html.Attributes exposing (class, download, height, href, id, style, width)
import Html.Events exposing (onClick)
import Json.Decode exposing (decodeValue)
import List
import Alt exposing (PageWidget, RouteParser)
import Ui exposing (Window, color, container, containerSmall)
import Alt exposing (Params)
import Flags exposing (flagsDecoder)


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
    , window : Window
    , device : E.Device
    }


type Msg
    = NothingYet
    | TeamShiftedRight
    | TeamShiftedLeft
    | WindowSizeChanged Window


formUrl : String
formUrl =
    "/form"


shiftL : List a -> List a
shiftL list =
    case list of
        [] ->
            []

        x :: rest ->
            rest ++ [ x ]


shiftR : List a -> List a
shiftR list =
    case List.reverse list of
        [] ->
            []

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
            ( { model | team = shiftedTeamLeft }, Cmd.none )

        TeamShiftedRight ->
            ( { model | team = shiftedTeamRight }, Cmd.none )

        WindowSizeChanged window ->
            ( { model | window = window, device = E.classifyDevice window }, Cmd.none )

        _ ->
            ( model, Cmd.none )


viewIntroBig : Window -> E.Element Msg
viewIntroBig { height, width } =
    let
        titleFontSize =
            round <| 150 / 2560 * toFloat width

        subtitleFontSize =
            round <| 75 / 2560 * toFloat width

        linkFontSize =
            round <| 40 / 2560 * toFloat width
    in
    E.column
        [ E.width E.fill
        , E.padding 50
        , E.spacingXY 20 20
        , E.htmlAttribute (style "min-height" "calc(100vh)")
        , B.color color.purple
        , B.image <| Asset.filepath Asset.largeIntro
        ]
        [ viewTitleBig "TÁBOR BIZÓN - 2021" titleFontSize
        , viewSubtitleBig "Putovanie za betlehemskou hviezdou" subtitleFontSize
        , viewSubmitLinkIntroBig "PRIHLÁSIŤ" linkFontSize
        ]


viewIntroSmall : E.Element Msg
viewIntroSmall =
    E.column
        [ E.width E.fill
        , E.htmlAttribute (style "min-height" "calc(80vh)")
        , B.color color.purple
        , E.spacingXY 0 30
        ]
        [ viewTitleSmall "TÁBOR BIZÓN" 30
        , viewSubtitleSmall "Putovanie za betlehemskou hviezdou" 16
        , viewSubmitLinkIntroSmall "PRIHLÁSIŤ" 16
        ]


viewTitleBig : String -> Int -> E.Element Msg
viewTitleBig label fontSize =
    E.row
        [ F.size fontSize
        , E.centerY

        -- , E.paddingXY 0 20
        , F.color color.white
        , F.bold
        ]
        [ E.text label ]


viewTitleSmall : String -> Int -> E.Element Msg
viewTitleSmall label fontSize =
    E.row
        [ F.size fontSize
        , E.centerX
        , E.centerY
        , F.bold
        , F.color color.white
        ]
        [ E.text label ]


viewSubtitleBig : String -> Int -> E.Element Msg
viewSubtitleBig label fontSize =
    E.row
        [ F.size fontSize
        , E.centerY
        , E.paddingXY 0 20
        , F.color (E.rgb255 210 197 227)
        ]
        [ E.text label ]


viewSubtitleSmall : String -> Int -> E.Element Msg
viewSubtitleSmall label fontSize =
    E.row
        [ F.size fontSize
        , E.centerY
        , E.centerX
        , F.bold
        , F.color color.pink
        ]
        [ E.text label ]


viewSubmitLinkIntroBig : String -> Int -> E.Element Msg
viewSubmitLinkIntroBig label fontSize =
    E.row
        [ E.centerY
        , E.padding 20
        , F.size fontSize
        , B.color color.red
        , F.color color.white
        , Bo.rounded 3
        , E.mouseOver [ B.color color.lightRed ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text label } ]


viewSubmitLinkIntroSmall : String -> Int -> E.Element Msg
viewSubmitLinkIntroSmall label fontSize =
    E.row
        [ E.centerY
        , E.centerX
        , E.padding 20
        , F.size fontSize
        , B.color (E.rgb255 250 105 128)
        , F.color (E.rgb255 255 255 255)
        , Bo.rounded 3
        , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text label } ]


viewAboutUsBig : List Animator -> Window -> E.Element Msg
viewAboutUsBig model { width } =
    container width <|
        [ viewSectionTitle "O NÁS" width
        , viewAboutUsText 20
        , viewAboutUsPhoto
        , viewSubsectionTitle "Animatori" 40
        , viewTeam model width
        ]


viewAboutUsSmall : List Animator -> Window -> E.Element Msg
viewAboutUsSmall team { width } =
    containerSmall <|
        [ viewSectionTitle "O NÁS" width
        , viewAboutUsText 14
        , viewAboutUsPhoto
        , viewSubsectionTitle "Animatori" 24
        , viewTeam team width
        ]


viewSectionTitle : String -> Int -> E.Element Msg
viewSectionTitle title width =
    let
        sectionTitleFontSize =
            max 32 <|
                min 100 <|
                    round <|
                        100
                            / 1680
                            * toFloat width
    in
    E.row [ F.size sectionTitleFontSize, E.centerX ] [ E.text title ]


viewSubsectionTitle : String -> Int -> E.Element Msg
viewSubsectionTitle subtitle fontSize =
    E.row [ F.size fontSize, E.centerX ] [ E.text subtitle ]


viewAboutUsText : Int -> E.Element Msg
viewAboutUsText fontSize =
    let
        t =
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim nisl, sodales vitae purus vitae, porttitor sollicitudin massa. Morbi pharetra mi luctus, tincidunt enim at, placerat augue. Cras eu cursus diam. Nunc laoreet eros risus, at consectetur felis tempus a. Maecenas ipsum nunc, sollicitudin feugiat luctus sed, consectetur ac mauris. Nunc dictum fermentum sem at feugiat. Maecenas malesuada erat sed erat feugiat condimentum. Morbi sed neque at diam lobortis efficitur in sed nisi. Nunc commodo purus at neque placerat, sit amet hendrerit risus placerat. Donec bibendum quam a velit semper, nec porttitor lacus pharetra. Morbi malesuada metus at posuere bibendum. Donec id risus facilisis, feugiat nulla id, fermentum velit. Vestibulum id ultricies ex, et commodo mi. Ut aliquet iaculis dolor a sollicitudin. Aenean rhoncus facilisis augue, nec pharetra sapien iaculis vel. Nam rhoncus convallis dolor vel consectetur. "
    in
    E.row []
        [ E.paragraph [ F.justify, F.size fontSize ]
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
        , E.row
            [ E.centerX
            , E.width E.fill

            -- , F.size 16
            ]
            [ E.el
                [ E.centerX
                , E.htmlAttribute
                    (style "overflow-wrap" "break-word")
                ]
              <|
                E.text name
            ]
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
        [ E.row
            [ E.centerY
            , E.width E.fill
            , E.height E.fill

            -- , E.explain Debug.todo
            ]
            [ E.image
                [ alignment
                , E.mouseOver [ B.color <| E.rgb255 222 222 222 ]
                , Ev.onClick clickEventMsg
                ]
                { src = Asset.filepath arrow, description = description }
            ]
        ]


viewTeam : List Animator -> Int -> E.Element Msg
viewTeam animators width =
    let
        numSelected =
            min 5 <| round <| 5 / 1680 * toFloat width

        selectedTeam =
            List.take numSelected animators

        l =
            List.length animators

        animatorList =
            viewArrow l Asset.icons.arrowBack L :: List.map (viewAnimator l) selectedTeam ++ [ viewArrow l Asset.icons.arrowForth R ]
    in
    E.row [ E.spacing 10 ] animatorList


viewDocumentsTable : List DocumentFile -> Int -> E.Element Msg
viewDocumentsTable documents fontSize =
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
    E.table
        [ F.size fontSize, E.width E.fill ]
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


viewDocumentsBig : List DocumentFile -> Window -> E.Element Msg
viewDocumentsBig documents { width } =
    container width <|
        [ viewSectionTitle "DOKUMENTY" width
        , viewDocumentsTable documents 20
        ]


viewDocumentsSmall : List DocumentFile -> Window -> E.Element Msg
viewDocumentsSmall documents { width } =
    containerSmall <|
        [ viewSectionTitle "DOKUMENTY" width
        , viewDocumentsTable documents 13
        ]


viewSubmitLinkHome : String -> Int -> E.Element Msg
viewSubmitLinkHome label fontSize =
    E.row
        [ E.centerX
        , E.padding 20
        , F.size fontSize
        , B.color (E.rgb255 250 105 128)
        , F.color (E.rgb255 255 255 255)
        , Bo.rounded 3
        , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
        ]
        [ E.link [ E.mouseOver [ F.color (E.rgb255 255 255 255) ] ] { url = formUrl, label = E.text label } ]


viewSubmitOption : Window -> E.Element Msg
viewSubmitOption { width } =
    let
        linkFontSize =
            min 40 <| max 16 <| round <| 40 / 1680 * toFloat width
    in
    container width <|
        [ viewSectionTitle "REGISTRÁCIA" width
        , viewSubmitLinkHome "TU" linkFontSize
        ]


viewContactLinks : Int -> E.Element Msg
viewContactLinks width =
    let
        linksPadding =
            min 40 <| max 10 <| round <| 40 / 1680 * toFloat width

        iconsSize =
            min 40 <| max 20 <| round <| 40 / 1680 * toFloat width

        linkAttributes =
            [ E.centerX, E.padding linksPadding ]

        linkImage imageSrc description =
            E.image [ E.height <| E.px iconsSize ] { src = Asset.filepath imageSrc, description = description }

        emailFontSize =
            min 40 <| max 20 <| round <| 40 / 1680 * toFloat width
    in
    E.column [ E.width E.fill ]
        [ E.row
            [ E.spacingXY 0 0
            , E.width E.fill
            , E.centerX
            ]
            [ E.el
                [ F.center
                , E.centerX
                , E.padding 20
                , F.color color.grey
                , F.size emailFontSize
                ]
                (E.text "tabor@bizon.sk")
            ]
        , E.row
            [ E.spacingXY 0 0
            , E.width E.fill
            , E.centerX
            ]
            [ E.link linkAttributes { url = "/", label = linkImage Asset.icons.web "web" }
            , E.link linkAttributes { url = "https://www.facebook.com/taborbizon", label = linkImage Asset.icons.facebook "facebook" }
            , E.link linkAttributes { url = "https://www.instagram.com/taborbizon", label = linkImage Asset.icons.instagram "instagram" }
            ]
        ]


viewContacts : Window -> E.Element Msg
viewContacts { width } =
    container width <|
        [ viewSectionTitle "KONTAKTY" width
        , viewContactLinks width
        ]


view : Model -> E.Element Msg
view model =
    let
        viewIntro =
            case model.device.class of
                E.Phone ->
                    viewIntroSmall

                _ ->
                    viewIntroBig model.window

        viewAboutUs =
            case model.device.class of
                E.Phone ->
                    viewAboutUsSmall model.team model.window

                _ ->
                    viewAboutUsBig model.team model.window

        viewDocuments =
            case model.device.class of
                E.Phone ->
                    viewDocumentsSmall model.documents model.window

                _ ->
                    viewDocumentsBig model.documents model.window

        space =
            case model.device.class of
                E.Phone ->
                    40

                _ ->
                    150
    in
    E.column
        [ E.width E.fill
        , E.spacing space
        ]
    <|
        [ viewIntro
        , viewAboutUs
        , viewDocuments
        , viewSubmitOption model.window
        ]
            ++ (if model.device.class /= E.Phone then
                    [ viewContacts model.window
                    ]

                else
                    [ E.row
                        [ E.width E.fill
                        , E.height <| E.px 50
                        ]
                        []
                    ]
               )


init : Params -> ( Model, Cmd Msg )
init params =
    let
        team =
            [ { name = "Margi", image = Asset.teamImages.margareta }
            , { name = "Jakob", image = Asset.teamImages.jakob }
            , { name = "Monika", image = Asset.teamImages.monika }
            , { name = "Debora", image = Asset.teamImages.debora }
            , { name = "Sona", image = Asset.teamImages.sona }
            , { name = "Vratko", image = Asset.teamImages.vratko }
            , { name = "Pravko", image = Asset.teamImages.pravko }
            , { name = "Matus", image = Asset.teamImages.matus }
            , { name = "Simon", image = Asset.teamImages.simon }
            ]

        window =
            case decodeValue flagsDecoder params.flags of
                Ok decodedWindow ->
                    decodedWindow

                Err _ ->
                    { width = 700, height = 100 }
    in
    ( { team = team
      , documents =
            [ { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            , { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            , { name = "Zdravotný dotazník", file = Asset.documentFiles.zdravotnyDotaznik }
            ]
      , window = window
      , device = E.classifyDevice window
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    onResize <|
        \width height ->
            WindowSizeChanged { width = width, height = height }


initPage : RouteParser -> PageWidget Model Msg Params
initPage p =
    let
        htmlView model =
            E.layout [] <| view model
    in
    { init = ( init, p )
    , update = update
    , subscriptions = subscriptions
    , view = htmlView
    }
