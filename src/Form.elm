module Form exposing (initPage)

import Alt exposing (PageWidget, Params, RouteParser)
import Asset
import Browser
import Browser.Events exposing (onResize)
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Input as I
import Element.Lazy as L
import Flags exposing (flagsDecoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode exposing (decodeValue)
import Ui exposing (Window, color, container, containerFormBigDesktop, containerFormDesktop, containerFormPhone, containerFormTablet, containerSmall)



-- MAIN
-- main =
--     Browser.sandbox { init = init, update = update, view = view }
-- MODEL


type alias Model =
    { childName : String
    , address : String
    , birthDate : String
    , adultName : String
    , adultPhone : String
    , adultEmail : String
    , tshirtSize : String
    , specialDiet : String
    , submitted : Bool
    , consented : Bool
    , window : Window
    , device : E.Device
    }


init : Params -> ( Model, Cmd Msg )
init params =
    let
        window =
            case decodeValue flagsDecoder params.flags of
                Ok decodedWindow ->
                    decodedWindow

                Err _ ->
                    { width = 700, height = 100 }
    in
    ( { childName = ""
      , address = ""
      , birthDate = ""
      , adultName = ""
      , adultPhone = ""
      , adultEmail = ""
      , tshirtSize = "detské XS (5-6 rokov 110/116)"
      , specialDiet = ""
      , submitted = False
      , consented = False
      , window = window
      , device = E.classifyDevice window
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChildNameChanged String
    | AddressChanged String
    | BirthDateChanged String
    | AdultNameChanged String
    | AdultPhoneChanged String
    | AdultEmailChanged String
    | TshirtSizeChanged String
    | SpecialDietChanged String
    | SubmittedChanged Bool
    | ConsentedChanged Bool
    | FormSubmitted
    | WindowSizeChanged Window


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChildNameChanged childName ->
            ( { model | childName = childName }, Cmd.none )

        AddressChanged address ->
            ( { model | address = address }, Cmd.none )

        BirthDateChanged birthDate ->
            ( { model | birthDate = birthDate }, Cmd.none )

        AdultNameChanged adultName ->
            ( { model | adultName = adultName }, Cmd.none )

        AdultPhoneChanged adultPhone ->
            ( { model | adultPhone = adultPhone }, Cmd.none )

        AdultEmailChanged adultEmail ->
            ( { model | adultEmail = adultEmail }, Cmd.none )

        TshirtSizeChanged tshirtSize ->
            ( { model | tshirtSize = tshirtSize }, Cmd.none )

        SpecialDietChanged specialDiet ->
            ( { model | specialDiet = specialDiet }, Cmd.none )

        ConsentedChanged consented ->
            ( { model | consented = consented }, Cmd.none )

        SubmittedChanged submitted ->
            ( { model | submitted = submitted }, Cmd.none )

        FormSubmitted ->
            ( model, Cmd.none )

        WindowSizeChanged window ->
            ( { model | window = window, device = E.classifyDevice window }, Cmd.none )



-- VIEW


viewDecorativeCol : Int -> E.Element Msg
viewDecorativeCol width =
    let
        columnWidth =
            round <| 1280 / 1706 * toFloat width / 2
    in
    E.column
        [ E.width <| E.px columnWidth
        , E.height E.fill
        , B.color color.purple
        , Bo.widthEach { top = 10, bottom = 0, right = 0, left = 0 }
        , Bo.color color.white
        , E.alignBottom
        ]
        [ E.row
            [ E.width <| E.px columnWidth
            , E.height E.fill
            , E.alignBottom
            ]
            [ E.image
                [ E.width <| E.fillPortion 1
                , E.alignBottom
                ]
                { src = Asset.filepath Asset.baltazar
                , description = "Baltazar"
                }
            , E.image
                [ E.width <| E.fillPortion 1
                , E.alignBottom
                ]
                { src = Asset.filepath Asset.gaspar
                , description = "Gaspar"
                }
            , E.image
                [ E.width <| E.fillPortion 1
                , E.alignBottom
                ]
                { src = Asset.filepath Asset.melichar
                , description = "melichar"
                }
            ]
        ]


view : Model -> E.Element Msg
view model =
    let
        decorativeCol =
            case model.device.class of
                E.Desktop ->
                    [ viewDecorativeCol model.window.width ]

                E.BigDesktop ->
                    [ viewDecorativeCol model.window.width ]

                _ ->
                    []

        viewForm =
            case model.device.class of
                E.BigDesktop ->
                    containerFormBigDesktop <| viewFormBig model model.window

                E.Desktop ->
                    containerFormDesktop <| viewFormBig model model.window

                E.Tablet ->
                    containerFormTablet <| viewFormSmall model model.window

                E.Phone ->
                    containerFormPhone <| viewFormSmall model model.window
    in
    E.row
        [ E.width E.fill
        , E.height E.fill
        ]
    <|
        E.column
            [ E.width E.fill
            , E.height E.fill
            , E.spacingXY 0 20
            , E.htmlAttribute (style "min-height" "calc(100vh)")
            ]
            [ viewForm ]
            :: decorativeCol


viewSectionTitle : String -> Int -> E.Element Msg
viewSectionTitle title fontSize =
    E.row [ F.size fontSize, E.centerX ] [ E.paragraph [ F.justify, F.center ] [ E.text title ] ]


viewStringInput : String -> String -> (String -> Msg) -> List (E.Attribute Msg) -> E.Element Msg
viewStringInput label value msg additionalAttributes =
    I.text
        ([ E.width E.fill ]
            ++ additionalAttributes
        )
        { onChange = msg
        , text = value
        , placeholder = Nothing --Just <| I.placeholder [] <| E.text "Type here"
        , label = I.labelAbove [] <| E.paragraph [ F.justify ] [ E.text label ]
        }


viewLongTextInput : String -> List (E.Attribute Msg) -> E.Element Msg
viewLongTextInput value additionalAttributes =
    I.multiline
        ([ E.width E.fill
         , E.height <| E.px 100
         , Bo.rounded 6
         ]
            ++ additionalAttributes
        )
        { onChange = SpecialDietChanged
        , text = value
        , placeholder = Nothing
        , label = I.labelAbove [] <| E.text "Špeciálna strava / diéta"
        , spellcheck = True
        }


viewRadioInput : String -> List (E.Attribute Msg) -> E.Element Msg
viewRadioInput tshirtSize additionalAttributes =
    E.el ([] ++ additionalAttributes) <|
        I.radio
            [ E.padding 10
            , E.spacing 10
            ]
            { onChange = TshirtSizeChanged
            , selected = Just tshirtSize
            , label = I.labelAbove [] <| E.text "Veľkosť trička pre dieťa"
            , options =
                [ I.option "detské XS (5-6 rokov 110/116)" <| E.paragraph [ F.justify ] [ E.text "detské XS (5-6 rokov 110/116)" ]
                , I.option "detské S (7-8 rokov 122/128)" <| E.paragraph [ F.justify ] [ E.text "detské S (7-8 rokov 122/128)" ]
                , I.option "detské M (9-10 rokov 134/140)" <| E.paragraph [ F.justify ] [ E.text "detské M (9-10 rokov 134/140)" ]
                , I.option "detské L (11-12 rokov 146/152)" <| E.paragraph [ F.justify ] [ E.text "detské L (11-12 rokov 146/152)" ]
                , I.option "detské XL (12-13 rokov 158/164)" <| E.paragraph [ F.justify ] [ E.text "detské XL (12-13 rokov 158/164)" ]
                , I.option "dospelé XS" <| E.paragraph [ F.justify ] [ E.text "dospelé XS" ]
                , I.option "dospelé S" <| E.paragraph [ F.justify ] [ E.text "dospelé SV" ]
                , I.option "dospelé M" <| E.paragraph [ F.justify ] [ E.text "dospelé M" ]
                , I.option "dospelé L" <| E.paragraph [ F.justify ] [ E.text "dospelé L" ]
                , I.option "dospelé XL" <| E.paragraph [ F.justify ] [ E.text "dospelé XL" ]
                , I.option "dospelé XXL" <| E.paragraph [ F.justify ] [ E.text "dospelé XXL" ]
                ]
            }


viewCheckbox : Bool -> (Bool -> Msg) -> String -> Int -> E.Element Msg
viewCheckbox value msg label fontSize =
    I.checkbox [ E.width E.fill ]
        { onChange = msg
        , icon = I.defaultCheckbox
        , checked = value
        , label = I.labelAbove [] <| E.paragraph [ F.justify, F.size fontSize ] [ E.text label ]
        }


viewSubmitButton : E.Element Msg
viewSubmitButton =
    I.button
        [ E.padding 15
        , B.color color.red
        , F.color color.white
        , Bo.rounded 3
        , E.mouseOver [ B.color color.lightRed ]
        ]
        { onPress = Just FormSubmitted, label = E.text "Odoslať" }


viewFormBig : Model -> Window -> List (E.Element Msg)
viewFormBig model { width } =
    [ E.row
        [ E.width E.fill
        , E.height <| E.px 80
        ]
        []
    , viewSectionTitle "ZAVAZNA REGISTRÁCIA" 60
    , E.row
        [ E.width E.fill
        , F.size 13
        , E.centerX
        , E.height E.fill
        , E.spacingXY 20 0
        ]
        [ E.column
            [ E.width <| E.fillPortion 2
            , E.alignLeft
            , E.spacingXY 0 20
            , E.height E.fill
            ]
            [ viewStringInput "Meno a priezvisko dieťaťa" model.childName ChildNameChanged [ E.alignLeft, E.width E.fill ]
            , viewStringInput "Adresa bydliska" model.address AddressChanged [ E.alignLeft, E.width E.fill ]
            , viewStringInput "Dátum narodenia" model.birthDate BirthDateChanged [ E.alignLeft, E.width E.fill ]
            , viewStringInput "Meno a priezvisko zákonného zástupcu" model.adultName AdultNameChanged [ E.alignLeft, E.width E.fill ]
            , viewStringInput "Telefónne číslo zákonného zástupcu" model.adultPhone AdultPhoneChanged [ E.alignLeft, E.width E.fill ]
            , viewStringInput "E-mail zákonného zástupcu" model.adultEmail AdultEmailChanged [ E.alignLeft, E.width E.fill ]
            ]
        , E.column
            [ E.width <| E.fillPortion 2
            , E.spacingXY 0 20
            , E.alignTop
            , E.alignRight
            ]
            [ viewLongTextInput model.specialDiet [ E.alignRight, E.width E.fill ]
            , viewRadioInput model.tshirtSize [ E.alignRight, E.width E.fill ]
            ]
        ]
    , E.row
        [ E.width E.fill
        , E.centerX
        , E.height E.fill
        ]
        [ E.column [ E.width E.fill, E.spacing 20, E.height E.fill ]
            [ viewCheckbox model.submitted SubmittedChanged "Týmto záväzne prihlasujem svoje dieťa do detského letného tábora Bizón a zároveň čestne vyhlasujem, že v prípade, ak si moje dieťa vezme do tábora mobil, peňažnú hotovosť, šperky alebo iné cennosti, preberám plnú zodpovednosť v prípade ich straty alebo odcudzenia." 13
            , viewCheckbox model.consented ConsentedChanged "Týmto dávam dobrovoľne vyslovený súhlas občianskemu združenie eRko - HKSD v zmysle zákona Zákon č. 18/2018 Z. z. Zákon o ochrane osobných údajov a o zmene a doplnení niektorých zákonov v platnom znení (ďalej len \"zákon\") so spracovaním osobných údajov môjho dieťaťa, v rozsahu meno, priezvisko, adresa bydliska a rodné číslo pre účely spracovania súvisiace s organizáciou detského letného tábora Bizón. Súhlas udeľujem do 31.12.2021. Po tomto termíne môžu byť tieto údaje použité v upravenej forme len na účely štatistiky a evidencie. Zároveň vyhlasujem, že som si vedomý svojich práv vyplývajúcich zo zákona. " 13
            , viewSubmitButton
            ]
        ]
    , E.row
        [ E.width E.fill
        , E.height <| E.px 80
        ]
        []
    ]


viewFormSmall : Model -> Window -> List (E.Element Msg)
viewFormSmall model { width } =
    [ E.column [ E.width E.fill, E.spacingXY 0 20 ]
        [ E.row
            [ E.width E.fill
            , E.height <| E.px 50
            ]
            []
        , viewSectionTitle "ZAVAZNA REGISTRÁCIA" 32
        , viewStringInput "Meno a priezvisko dieťaťa" model.childName ChildNameChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewStringInput "Adresa bydliska" model.address AddressChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewStringInput "Dátum narodenia" model.birthDate BirthDateChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewStringInput "Meno a priezvisko zákonného zástupcu" model.adultName AdultNameChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewStringInput "Telefónne číslo zákonného zástupcu" model.adultPhone AdultPhoneChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewStringInput "E-mail zákonného zástupcu" model.adultEmail AdultEmailChanged [ E.centerX, F.size 13, E.width E.fill ]
        , viewLongTextInput model.specialDiet [ E.centerX, F.size 13, E.width E.fill ]
        , viewRadioInput model.tshirtSize [ E.centerX, F.size 13, E.width E.fill ]
        , viewCheckbox model.submitted SubmittedChanged "Týmto záväzne prihlasujem svoje dieťa do detského letného tábora Bizón a zároveň čestne vyhlasujem, že v prípade, ak si moje dieťa vezme do tábora mobil, peňažnú hotovosť, šperky alebo iné cennosti, preberám plnú zodpovednosť v prípade ich straty alebo odcudzenia." 13
        , viewCheckbox model.consented ConsentedChanged "Týmto dávam dobrovoľne vyslovený súhlas občianskemu združenie eRko - HKSD v zmysle zákona Zákon č. 18/2018 Z. z. Zákon o ochrane osobných údajov a o zmene a doplnení niektorých zákonov v platnom znení (ďalej len \"zákon\") so spracovaním osobných údajov môjho dieťaťa, v rozsahu meno, priezvisko, adresa bydliska a rodné číslo pre účely spracovania súvisiace s organizáciou detského letného tábora Bizón. Súhlas udeľujem do 31.12.2021. Po tomto termíne môžu byť tieto údaje použité v upravenej forme len na účely štatistiky a evidencie. Zároveň vyhlasujem, že som si vedomý svojich práv vyplývajúcich zo zákona. " 13
        , viewSubmitButton
        ]
    , E.row
        [ E.width E.fill
        , E.height <| E.px 50
        ]
        []
    ]


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
