module Filter exposing (Filter, FilterSettings, defaultFilters, filterArticles, fromString, toString)

import Article exposing (Article)
import Dict exposing (Dict)
import Time
import Url exposing (percentDecode, percentEncode)


type alias FilterSettings =
    Dict String String


type alias Filter =
    { name : String
    , slug : String
    , selector : Article -> Maybe String
    , valueDecorator : String -> String
    }


filterArticles : Filter -> FilterSettings -> List Article -> List Article
filterArticles filter env =
    List.filter (matchArticle filter env)


matchArticle : Filter -> FilterSettings -> Article -> Bool
matchArticle filter env article =
    case Dict.get filter.slug env of
        Just val ->
            case filter.selector article of
                Just x ->
                    x == val

                Nothing ->
                    False

        Nothing ->
            True


defaultFilters : List Filter
defaultFilters =
    let
        pubYear =
            .pubDate >> Time.toYear Time.utc >> String.fromInt
    in
    [ Filter "Autor" "autor" (Just << .author) identity
    , Filter "Rubrika" "rubrika" .category identity
    , Filter "Seriál" "serial" .serialID serialDecorator
    , Filter "Rok" "rok" (Just << pubYear) identity
    ]


serialDecorator : String -> String
serialDecorator s =
    case s of
        "ghetto" ->
            "Příběhy z ghetta"

        "depozitar" ->
            "Z muzejního depozitáře"

        "krajiny" ->
            "Krajiny Boskovicka"

        "stromy" ->
            "Život pod stromy"

        "jazyk" ->
            "Rendez-vous s jazykem"

        "historie" ->
            "Pohledy do historie"

        "osmicky" ->
            "Osmičková výročí"

        _ ->
            s


toString : FilterSettings -> String
toString settings =
    let
        encodePair ( key, val ) =
            percentEncode key ++ "=" ++ percentEncode val
    in
    settings
        |> Dict.toList
        |> List.map encodePair
        |> String.join "&"


fromString : String -> FilterSettings
fromString str =
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
