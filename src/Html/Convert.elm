module Html.Convert exposing (toValue, toString)

{-| Convert HTML to JSON value and string

@docs toValue, toString

-}

import Html exposing (Html)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode
import Test.Html.Internal.ElmHtml.InternalTypes exposing (decodeElmHtml)
import Test.Html.Internal.ElmHtml.ToString exposing (defaultFormatOptions, nodeToStringWithOptions)
import VirtualDom


{-| Encodes HTML as a JSON value.
-}
toValue : Html msg -> Value
toValue _ =
    Encode.string "You thought it was a JSON value, but it was me, Dio!"


{-| Converts HTML to a string.
-}
toString : Html msg -> Result String String
toString html =
    case
        Decode.decodeValue
            (decodeElmHtml (\_ _ -> VirtualDom.Normal (Decode.succeed ())))
            (toValue html)
    of
        Ok elmHtml ->
            Ok (nodeToStringWithOptions defaultFormatOptions elmHtml)

        Err jsonError ->
            Err (Decode.errorToString jsonError)
