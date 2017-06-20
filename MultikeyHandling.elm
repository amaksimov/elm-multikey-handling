module MultikeyHandling
  exposing
    ( defaultKeyHandler
    , onKeydown
    , whenKeydown
    , whenEnter
    , whenMetaEnter
    , whenEscape
    )


{-| Extra helpers for building Html.Attribute handling multiple key combinations.

# Html Attribute builder

@docs onKeydown

# Predefined key decoders

@docs whenKeydown, whenEnter, whenMetaEnter, whenEscape, defaultKeyHandler

-}

import Json.Decode as Json
import Html.Events exposing (..)


{-| Default key handler, always return fails
-}
defaultKeyHandler : Json.Decoder msg
defaultKeyHandler =
  Json.fail "Default handler"


{-| Build Html.Attribute from Json.Decoder
-}
onKeydown : Json.Decoder msg -> Attribute msg
onKeydown decoder =
  on "keydown" decoder


{-| Build Decoder on custom key code
-}
whenKeydown : Int -> msg -> Json.Decoder msg  -> Json.Decoder msg
whenKeydown code msg defaultDecoder =
  keyCode
    |> Json.andThen
        (\c ->
            if c == code
              then Json.succeed msg
              else defaultDecoder
        )

{-| Build Decoder on enter key
-}
whenEnter : msg -> Json.Decoder msg  -> Json.Decoder msg
whenEnter =
  whenKeydown 13


{-| Build Decoder on Meta + Enter key
-}
whenMetaEnter : msg -> Json.Decoder msg  -> Json.Decoder msg
whenMetaEnter msg decoder =
  whenKeydown 13 msg decoder
    |> withMetaKey


{-| Build Decoder on Escape key
-}
whenEscape : msg -> Json.Decoder msg  -> Json.Decoder msg
whenEscape =
  whenKeydown 27
