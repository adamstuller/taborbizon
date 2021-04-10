module Form exposing (Model, Msg, init, update, view)

import Asset
import Browser
import Element as E
import Element.Background as B
import Element.Border as Bo
import Element.Events as Ev
import Element.Font as F
import Element.Input as I
import Element.Lazy as L
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Ui exposing (color)



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
    }


init : () -> ( Model, Cmd Msg )
init () =
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



-- VIEW


view : Model -> E.Element Msg
view model =
    E.row
        [ E.width E.fill
        , E.htmlAttribute (style "min-height" "calc(120vh)")
        ]
        [ E.column
            [ E.width <| E.fillPortion 2
            , E.height E.fill

            -- , E.explain Debug.todo
            ]
          <|
            viewForm model
        , E.column
            [ E.width <| E.fillPortion 2
            , E.height E.fill
            , B.color color.purple
            , Bo.widthEach { top = 10, bottom = 0, right = 0, left = 0 }
            , Bo.color color.white
            ]
            [ E.row [ E.width E.fill, E.height E.fill, E.spaceEvenly ]
                [ E.image
                    [ E.height <| E.px 700
                    , E.alignBottom
                    , E.paddingXY 30 0
                    ]
                    { src = Asset.filepath Asset.baltazar
                    , description = "Baltazar"
                    }
                , E.image
                    [ E.height <| E.px 700
                    , E.alignBottom
                    , E.paddingXY 30 0
                    ]
                    { src = Asset.filepath Asset.gaspar
                    , description = "Gaspar"
                    }
                , E.image
                    [ E.height <| E.px 700
                    , E.alignBottom
                    , E.paddingXY 30 0
                    ]
                    { src = Asset.filepath Asset.melichar
                    , description = "melichar"
                    }
                ]
            ]
        ]


viewSectionTitle : String -> E.Element Msg
viewSectionTitle title =
    E.row [ F.size 60, E.centerX ] [ E.text title ]


viewStringInput : String -> String -> (String -> Msg) -> E.Element Msg
viewStringInput label value msg =
    I.text
        [ E.width <| E.maximum 300 E.fill
        , E.alignLeft
        ]
        { onChange = msg
        , text = value
        , placeholder = Nothing --Just <| I.placeholder [] <| E.text "Type here"
        , label = I.labelAbove [] <| E.text label
        }


viewLongTextInput : String -> E.Element Msg
viewLongTextInput value =
    I.multiline
        [ E.width <| E.maximum 300 E.fill
        , E.height <| E.px 150
        , E.alignRight
        , Bo.rounded 6

        -- , Bo.width 2
        -- , Bo.color <| E.rgb255 0x72 0x9F 0xCF
        ]
        { onChange = SpecialDietChanged
        , text = value
        , placeholder = Nothing --Just <| I.placeholder [] <| E.text "Type your message"
        , label = I.labelAbove [] <| E.text "Špeciálna strava / diéta"
        , spellcheck = True
        }


viewForm : Model -> List (E.Element Msg)
viewForm model =
    [ E.row
        [ E.width E.fill
        , E.height <| E.fillPortion 3
        ]
        [ viewSectionTitle "ZAVAZNA REGISTRÁCIA" ]
    , E.row
        [ E.width <| E.maximum 700 E.fill
        , E.height <| E.fillPortion 6
        , F.size 13
        , E.centerX

        -- , E.explain Debug.todo
        ]
        [ E.column
            [ E.width <| E.fillPortion 2
            , E.height <| E.fillPortion 2
            , E.spaceEvenly
            , E.alignLeft
            ]
            [ viewStringInput "Meno a priezvisko dieťaťa" model.childName ChildNameChanged
            , viewStringInput "Adresa bydliska" model.address AddressChanged
            , viewStringInput "Dátum narodenia" model.birthDate BirthDateChanged
            , viewStringInput "Meno a priezvisko zákonného zástupcu" model.adultName AdultNameChanged
            , viewStringInput "Telefónne číslo zákonného zástupcu" model.adultPhone AdultPhoneChanged
            , viewStringInput "E-mail zákonného zástupcu" model.adultEmail AdultEmailChanged
            ]
        , E.column
            [ E.width <| E.fillPortion 2
            , E.height <| E.fillPortion 2
            , E.spaceEvenly

            -- , E.explain Debug.todo
            ]
            [ viewLongTextInput model.specialDiet
            , E.el [ E.alignRight, E.width <| E.maximum 300 E.fill ] <|
                I.radio
                    [ E.padding 10
                    , E.spacing 10
                    ]
                    { onChange = TshirtSizeChanged
                    , selected = Just model.tshirtSize
                    , label = I.labelAbove [] <| E.text "Veľkosť trička pre dieťa"
                    , options =
                        [ I.option "detské XS (5-6 rokov 110/116)" <| E.text "detské XS (5-6 rokov 110/116)"
                        , I.option "detské S (7-8 rokov 122/128)" <| E.text "detské S (7-8 rokov 122/128)"
                        , I.option "detské M (9-10 rokov 134/140)" <| E.text "detské M (9-10 rokov 134/140)"
                        , I.option "detské L (11-12 rokov 146/152)" <| E.text "detské L (11-12 rokov 146/152)"
                        , I.option "detské XL (12-13 rokov 158/164)" <| E.text "detské XL (12-13 rokov 158/164)"
                        , I.option "dospelé XS" <| E.text "dospelé XS"
                        , I.option "dospelé S" <| E.text "dospelé SV"
                        , I.option "dospelé M" <| E.text "dospelé M"
                        , I.option "dospelé L" <| E.text "dospelé L"
                        , I.option "dospelé XL" <| E.text "dospelé XL"
                        , I.option "dospelé XXL" <| E.text "dospelé XXL"
                        ]
                    }
            ]
        ]
    , E.row
        [ E.width <| E.maximum 700 E.fill
        , E.height <| E.fillPortion 5
        , E.centerX
        ]
        [ E.column [ E.width E.fill, E.spacing 20 ]
            [ I.checkbox [ F.size 13 ]
                { onChange = SubmittedChanged
                , icon = I.defaultCheckbox
                , checked = model.submitted
                , label = I.labelAbove [] <| E.paragraph [] [ E.text "Týmto záväzne prihlasujem svoje dieťa do detského letného tábora Bizón a zároveň čestne vyhlasujem, že v prípade, ak si moje dieťa vezme do tábora mobil, peňažnú hotovosť, šperky alebo iné cennosti, preberám plnú zodpovednosť v prípade ich straty alebo odcudzenia." ]
                }
            , I.checkbox [ F.size 13 ]
                { onChange = ConsentedChanged
                , icon = I.defaultCheckbox
                , checked = model.consented
                , label = I.labelAbove [] <| E.paragraph [] [ E.text "Týmto dávam dobrovoľne vyslovený súhlas občianskemu združenie eRko - HKSD v zmysle zákona Zákon č. 18/2018 Z. z. Zákon o ochrane osobných údajov a o zmene a doplnení niektorých zákonov v platnom znení (ďalej len \"zákon\") so spracovaním osobných údajov môjho dieťaťa, v rozsahu meno, priezvisko, adresa bydliska a rodné číslo pre účely spracovania súvisiace s organizáciou detského letného tábora Bizón. Súhlas udeľujem do 31.12.2021. Po tomto termíne môžu byť tieto údaje použité v upravenej forme len na účely štatistiky a evidencie. Zároveň vyhlasujem, že som si vedomý svojich práv vyplývajúcich zo zákona. " ]
                }
            , I.button
                [ E.padding 15
                , B.color (E.rgb255 250 105 128)
                , F.color (E.rgb255 255 255 255)
                , Bo.rounded 3
                , E.mouseOver [ B.color (E.rgb255 246 147 163) ]
                ]
                { onPress = Just FormSubmitted, label = E.text "Odoslať" }
            ]
        ]
    ]
