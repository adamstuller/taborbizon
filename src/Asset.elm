module Asset exposing (Asset, bizonLogo, camp, defaultAvatar, documentFiles, href, src, teamImages)

{-| Assets, such as images, videos, and audio. (We only have images for now.)

We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!

-}

import Html exposing (Attribute)
import Html.Attributes as Attr


type Asset
    = Image String
    | File String


type alias TeamImages =
    { monika : Asset
    , margareta : Asset
    }


teamImages : TeamImages
teamImages =
    { monika = image "monula.jpg"
    , margareta = image "meme.jpg"
    }


type alias DocumentFiles =
    { zdravotnyDotaznik : Asset
    }


documentFiles : DocumentFiles
documentFiles =
    { zdravotnyDotaznik = file "dotaznik.pdf"
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


image : String -> Asset
image filename =
    Image ("/assets/images/" ++ filename)


file : String -> Asset
file filename =
    File ("/assets/files/" ++ filename)



-- file : String -> File
-- USING IMAGES


src : Asset -> Attribute msg
src asset =
    case asset of
        Image url ->
            Attr.src url

        File url ->
            Attr.src url


href : Asset -> Attribute msg
href asset =
    case asset of
        Image url ->
            Attr.href url

        File url ->
            Attr.href url
