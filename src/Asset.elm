module Asset exposing (Image, camp, defaultAvatar, src, teamImages)

{-| Assets, such as images, videos, and audio. (We only have images for now.)

We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!

-}

import Html exposing (Attribute)
import Html.Attributes as Attr


type Image
    = Image String


type alias TeamImages =
    { monika : Image
    , margareta : Image
    }


teamImages : TeamImages
teamImages =
    { monika = image "monula.jpg"
    , margareta = image "meme.jpg"
    }



-- IMAGES
-- error : Image
-- error =
--     image "error.jpg"
-- loading : Image
-- loading =
--     image "loading.svg"


camp : Image
camp =
    image "taborbizon.jpg"


defaultAvatar : Image
defaultAvatar =
    image "smiley-cyrus.jpg"


image : String -> Image
image filename =
    Image ("/assets/images/" ++ filename)



-- USING IMAGES


src : Image -> Attribute msg
src (Image url) =
    Attr.src url
