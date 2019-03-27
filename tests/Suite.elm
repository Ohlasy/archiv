module Suite exposing (suite)

import Dict exposing (Dict)
import Expect exposing (Expectation)
import Filter exposing (fromString, toString)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Filter encoding & decoding"
        [ test "Decode filter settings" <|
            \_ ->
                let
                    settings =
                        fromString "foo%20bar=baz"

                    expected =
                        Dict.singleton "foo bar" "baz"
                in
                Expect.equal settings expected
        , test "Encode filter settings" <|
            \_ ->
                let
                    encoded =
                        "bar=baz&foo=ba%C5%BEe"

                    settings =
                        Dict.singleton "foo" "baže"
                            |> Dict.insert "bar" "baz"
                in
                Expect.equal (toString settings) encoded
        ]
