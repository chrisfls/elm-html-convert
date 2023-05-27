module Tests exposing (suite)

import Expect
import Html exposing (Html, div, node, text)
import Html.Attributes exposing (attribute, property)
import Html.Convert as Html
import Json.Encode as Encode
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Convert"
        [ test "toString" <|
            \_ ->
                Expect.equal
                    (Ok "<div visible=\"true\"><hello>world</hello>!</div>")
                    (Html.toString html)
        , test "toValue" <|
            \_ ->
                Expect.equal encodedHtml
                    (Html.toValue html |> Encode.encode 2)
        ]


html : Html msg
html =
    div
        [ property "hidden" (Encode.bool False)
        , attribute "visible" "true"
        ]
        [ node "hello" [] [ text "world" ]
        , text "!"
        ]


encodedHtml : String
encodedHtml =
    """{
  "$": 1,
  "c": "div",
  "d": {
    "hidden": false,
    "a3": {
      "visible": "true"
    }
  },
  "e": [
    {
      "$": 1,
      "c": "hello",
      "d": {},
      "e": [
        {
          "$": 0,
          "a": "world"
        }
      ],
      "b": 1
    },
    {
      "$": 0,
      "a": "!"
    }
  ],
  "b": 3
}"""
