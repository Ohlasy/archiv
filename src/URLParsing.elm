module URLParsing exposing (decodeHashString, decodeHashStringOrEmpty, encodeHashString)

import Dict exposing (Dict)
import Http exposing (decodeUri, encodeUri)


encodeHashString : Dict String String -> String
encodeHashString d =
    let
        encodePair ( key, val ) =
            encodeUri key ++ "=" ++ encodeUri val

        encodedPairs =
            List.map encodePair (Dict.toList d)

        encodedHash =
            String.join "&" encodedPairs
    in
    "#" ++ encodedHash


decodeHashStringOrEmpty : String -> Dict String String
decodeHashStringOrEmpty s =
    Maybe.withDefault Dict.empty (decodeHashString s)


decodeHashString : String -> Maybe (Dict String String)
decodeHashString startsWithHashMarkThenParams =
    case String.uncons startsWithHashMarkThenParams of
        Just ( '#', rest ) ->
            Just (decodeParams rest)

        Nothing ->
            Nothing

        _ ->
            Nothing


decodeParams : String -> Dict String String
decodeParams stringWithAmpersands =
    let
        eachParam =
            String.split "&" stringWithAmpersands

        eachPair =
            List.map (splitAtFirst '=') eachParam

        decodedPairs =
            List.filterMap decodePair eachPair
    in
    Dict.fromList decodedPairs


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
    case decodeUri key of
        Just key ->
            case decodeUri val of
                Just val ->
                    Just ( key, val )

                Nothing ->
                    Nothing

        Nothing ->
            Nothing
