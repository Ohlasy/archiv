module URLParsing exposing (decodeHashStringOrEmpty, encodeHashString)

import Dict exposing (Dict)
import Url exposing (percentDecode, percentEncode)


encodeHashString : Dict String String -> String
encodeHashString dict =
    let
        encodePair ( key, val ) =
            percentEncode key ++ "=" ++ percentEncode val
    in
    dict
        |> Dict.toList
        |> List.map encodePair
        |> String.join "&"


decodeHashStringOrEmpty : String -> Dict String String
decodeHashStringOrEmpty =
    decodeParams


decodeParams : String -> Dict String String
decodeParams str =
    str
        |> String.split "&"
        |> List.map (splitAtFirst '=')
        |> List.filterMap decodePair
        |> List.filter (\x -> x /= ( "", "" ))
        |> Dict.fromList


splitAtFirst : Char -> String -> ( String, String )
splitAtFirst c s =
    case firstOccurrence c s of
        Nothing ->
            ( s, "" )

        Just i ->
            ( String.left i s, String.dropLeft (i + 1) s )


firstOccurrence : Char -> String -> Maybe Int
firstOccurrence c s =
    case String.indexes (String.fromChar c) s of
        [] ->
            Nothing

        head :: _ ->
            Just head


decodePair : ( String, String ) -> Maybe ( String, String )
decodePair ( key, val ) =
    case percentDecode key of
        Just decodedKey ->
            case percentDecode val of
                Just decodedVal ->
                    Just ( decodedKey, decodedVal )

                Nothing ->
                    Nothing

        Nothing ->
            Nothing
