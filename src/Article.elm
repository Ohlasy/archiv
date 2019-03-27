module Article exposing (Article, articleDecoder, articleListDecoder)

import Iso8601
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Time


type alias Article =
    { relativeURL : String
    , title : String
    , author : String
    , perex : Maybe String
    , category : Maybe String
    , coverPhotoURL : Maybe String
    , serialID : Maybe String
    , pubDate : Time.Posix
    , tags : List String
    }


articleDecoder : Decoder Article
articleDecoder =
    succeed Article
        |> required "relativeURL" string
        |> required "title" string
        |> required "author" string
        |> required "perex" (nullable string)
        |> required "category" (nullable string)
        |> required "cover-photo" (nullable string)
        |> required "serial" (nullable string)
        |> required "pubDate" pubDateDecoder
        |> required "tags" (list string)


articleListDecoder : Decoder (List Article)
articleListDecoder =
    list articleDecoder


pubDateDecoder : Decoder Time.Posix
pubDateDecoder =
    string
        |> map preprocessTimestamp
        |> map Iso8601.toTime
        |> andThen
            (\s ->
                case s of
                    Ok d ->
                        succeed d

                    Err _ ->
                        fail "Error parsing ISO8601 timestamp"
            )


preprocessTimestamp : String -> String
preprocessTimestamp str =
    str
        |> String.replace " +0000" "Z"
        |> String.replace " " "T"
