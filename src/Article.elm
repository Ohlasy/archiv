module Article exposing (Article, articleDecoder, articleListDecoder)

import Iso8601 exposing (toTime)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import Time exposing (..)


type alias Article =
    { relativeURL : String
    , title : String
    , author : String
    , perex : Maybe String
    , category : Maybe String
    , coverPhotoURL : Maybe String
    , serialID : Maybe String
    , pubDate : Time.Posix
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


articleListDecoder : Decoder (List Article)
articleListDecoder =
    list articleDecoder


pubDateDecoder : Decoder Time.Posix
pubDateDecoder =
    string
        |> andThen
            (\s ->
                case toTime (patchTimestampFormat s) of
                    Err _ ->
                        fail "Error parsing ISO8601 timestamp"

                    Ok d ->
                        succeed d
            )


patchTimestampFormat : String -> String
patchTimestampFormat =
    String.replace " " "T" << String.replace " +0000" "Z"
