module Asset exposing
    ( Asset
    , bizonLogo
    , camp
    , defaultAvatar
    , documentFiles
    , filepath
    , href
    , icons
    , largeIntro
    , src
    , teamImages
    )

{-| Assets, such as images, videos, and audio. (We only have images for now.)

We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!

-}

import Html exposing (Attribute)
import Html.Attributes as Attr


type Asset
    = Image String
    | File String
    | Icon String


type alias TeamImages =
    { monika : Asset
    , margareta : Asset
    , debora : Asset
    , jakob : Asset
    , sona : Asset
    , pravko : Asset
    , vratko : Asset
    , simon : Asset
    , matus : Asset
    }


teamImages : TeamImages
teamImages =
    { monika = image "monula.jpg"
    , margareta = image "meme.jpg"
    , debora = image "dede.jpg"
    , jakob = image "jakob.jpg"
    , sona = image "sona.jpg"
    , pravko = image "pravko.jpg"
    , vratko = image "vratko.jpg"
    , simon = image "simon.jpg"
    , matus = image "matus.jpg"
    }


type alias DocumentFiles =
    { zdravotnyDotaznik : Asset
    }


documentFiles : DocumentFiles
documentFiles =
    { zdravotnyDotaznik = file "dotaznik.pdf"
    }


icons : { web : Asset, facebook : Asset, instagram : Asset, arrowForth : Asset, arrowBack : Asset }
icons =
    { web = icon "web.svg"
    , facebook = icon "facebook.svg"
    , instagram = icon "instagram.svg"
    , arrowForth = icon "arrow.svg"
    , arrowBack = icon "arrow back.svg"
    }



-- IMAGES
-- error : Image
-- error =
--     image "error.jpg"
-- loading : Image
-- loading =
--     image "loading.svg"


camp : Asset
camp =
    image "taborbizon.jpg"


defaultAvatar : Asset
defaultAvatar =
    image "smiley-cyrus.jpg"


bizonLogo : Asset
bizonLogo =
    image "bizonlogo.png"


largeIntro : Asset
largeIntro =
    image "LARGE.png"


image : String -> Asset
image filename =
    Image ("/assets/images/" ++ filename)


file : String -> Asset
file filename =
    File ("/assets/files/" ++ filename)


icon : String -> Asset
icon filename =
    Icon ("/assets/icons/" ++ filename)



-- file : String -> File
-- USING IMAGES


filepath : Asset -> String
filepath asset =
    case asset of
        Image url ->
            url

        File url ->
            url

        Icon url ->
            url


src : Asset -> Attribute msg
src asset =
    case asset of
        Image url ->
            Attr.src url

        File url ->
            Attr.src url

        Icon url ->
            Attr.src url


href : Asset -> Attribute msg
href asset =
    case asset of
        Image url ->
            Attr.href url

        File url ->
            Attr.href url

        Icon url ->
            Attr.href url
