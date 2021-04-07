module Form exposing (Model, Msg, init, update, view)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Grid as Grid
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



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


view : Model -> Html Msg
view model =
    Form.form []
        [ Form.group []
            [ Form.label [ for "childName" ] [ text "Meno a priezvisko dieťaťa" ]
            , Input.text [ Input.id "childName", Input.onInput ChildNameChanged, Input.value model.childName ]
            ]
        , Form.group []
            [ Form.label [ for "address" ] [ text "Adresa bydliska" ]
            , Input.text [ Input.id "address", Input.onInput AddressChanged, Input.value model.address ]
            ]
        , Form.group []
            [ Form.label [ for "brithDate" ] [ text "Dátum narodenia" ]
            , Input.date [ Input.id "brithDate", Input.onInput BirthDateChanged, Input.value model.birthDate ]
            ]
        , Form.group []
            [ Form.label [ for "adultName" ] [ text "Meno a priezvisko zákonného zástupcu" ]
            , Input.text [ Input.id "adultName", Input.onInput AdultNameChanged, Input.value model.adultName ]
            ]
        , Form.group []
            [ Form.label [ for "adultPhone" ] [ text "Telefónne číslo zákonného zástupcu" ]
            , Input.text [ Input.id "adultPhone", Input.onInput AdultPhoneChanged, Input.value model.adultPhone ]
            ]
        , Form.group []
            [ Form.label [ for "adultEmail" ] [ text "E-mail zákonného zástupcu" ]
            , Input.text [ Input.id "adultEmail", Input.onInput AdultEmailChanged, Input.value model.adultEmail ]
            ]
        , Form.group []
            [ Form.label [ for "tshirtSelect" ] [ text "Veľkosť trička pre dieťa" ]
            , Select.select [ Select.id "myselect", Select.onChange TshirtSizeChanged ]
                [ Select.item [] [ text "detské XS (5-6 rokov 110/116)" ]
                , Select.item [] [ text "detské S (7-8 rokov 122/128)" ]
                , Select.item [] [ text "detské M (9-10 rokov 134/140)" ]
                , Select.item [] [ text "detské L (11-12 rokov 146/152)" ]
                , Select.item [] [ text "detské XL (12-13 rokov 158/164)" ]
                , Select.item [] [ text "dospelé XS" ]
                , Select.item [] [ text "dospelé S" ]
                , Select.item [] [ text "dospelé M" ]
                , Select.item [] [ text "dospelé L" ]
                , Select.item [] [ text "dospelé XL" ]
                , Select.item [] [ text "dospelé XXL" ]
                ]
            ]
        , Form.group []
            [ Form.label [ for "specialDiet" ] [ text "Špeciálna strava / diéta" ]
            , Textarea.textarea [ Textarea.id "specialDiet", Textarea.onInput SpecialDietChanged, Textarea.value model.specialDiet ]
            ]
        , Form.group []
            [ Form.label [ for "submitCheck" ] [ text "Týmto záväzne prihlasujem svoje dieťa do detského letného tábora Bizón a zároveň čestne vyhlasujem, že v prípade, ak si moje dieťa vezme do tábora mobil, peňažnú hotovosť, šperky alebo iné cennosti, preberám plnú zodpovednosť v prípade ich straty alebo odcudzenia." ]
            , Checkbox.checkbox [ Checkbox.id "submitCheck", Checkbox.onCheck SubmittedChanged, Checkbox.indeterminate ] "Suhlasim"
            ]
        , Form.group []
            [ Form.label [ for "consentCheck" ] [ text "Týmto dávam dobrovoľne vyslovený súhlas občianskemu združenie eRko - HKSD v zmysle zákona Zákon č. 18/2018 Z. z. Zákon o ochrane osobných údajov a o zmene a doplnení niektorých zákonov v platnom znení (ďalej len \"zákon\") so spracovaním osobných údajov môjho dieťaťa, v rozsahu meno, priezvisko, adresa bydliska a rodné číslo pre účely spracovania súvisiace s organizáciou detského letného tábora Bizón. Súhlas udeľujem do 31.12.2021. Po tomto termíne môžu byť tieto údaje použité v upravenej forme len na účely štatistiky a evidencie. Zároveň vyhlasujem, že som si vedomý svojich práv vyplývajúcich zo zákona. " ]
            , Checkbox.checkbox [ Checkbox.id "consentCheck", Checkbox.onCheck ConsentedChanged, Checkbox.indeterminate ] "Suhlasim"
            ]
        , Button.button [ Button.primary, Button.onClick FormSubmitted ] [ text "Odoslať" ]
        ]
