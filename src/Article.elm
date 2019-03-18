module Article exposing (Article, articleDecoder, articleListDecoder)

import Date exposing (Date, fromString)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import String.Extra exposing (replace)


type alias Article =
    { relativeURL : String
    , title : String
    , author : String
    , perex : Maybe String
    , category : Maybe String
    , coverPhotoURL : Maybe String
    , serialID : Maybe String
    , pubDate : Date
    }


articleDecoder : Decoder Article
articleDecoder =
    decode Article
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


pubDateDecoder : Decoder Date
pubDateDecoder =
    string
        |> andThen
            (\s ->
                case Date.fromString (convertDateToISO8601 s) of
                    Err e ->
                        fail e

                    Ok d ->
                        succeed d
            )


convertDateToISO8601 : String -> String
convertDateToISO8601 =
    replace " " "T" << replace " +0000" ""
