module State exposing (..)

import Article exposing (..)
import Filter exposing (..)

import Http exposing (send, encodeUri, decodeUri)
import Json.Decode exposing (decodeString)
import Location exposing (openURL)
import URLParsing exposing (..)
import Dict exposing (Dict)
import Navigation exposing (modifyUrl)

-- TYPES

type alias DisplayState = {
    articles: List Article,
    filters: List Filter,
    settings: FilterSettings,
    searchQuery: String
}

type Model =
    Loading FilterSettings |
    Displaying DisplayState |
    Failed String

type Msg =
    ParseArticles (Result Http.Error String) |
    UpdateFilterValue Filter (Maybe String) |
    UpdateSearchQuery String |
    SubmitSearch |
    URLChange Navigation.Location |
    RemoveAllFilters

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    ParseArticles result -> case model of
        Loading settings -> case result of
            Ok s -> case decodeString articleListDecoder s of
                Ok articles ->
                    (Displaying (DisplayState articles defaultFilters settings ""), Cmd.none)
                Err e ->
                    (Failed (toString e), Cmd.none)
            Err e ->
                (Failed (toString e), Cmd.none)
        _ ->
            (Failed "Invalid state", Cmd.none)
    UpdateFilterValue f val -> case model of
        Displaying state ->
            let
                newSettings =
                    case val of
                        Just val -> Dict.insert f.slug val state.settings
                        Nothing -> Dict.remove f.slug state.settings
                newHash = encodeHashString newSettings
            in (model, modifyUrl newHash)
        _ ->
            (Failed "Invalid state", Cmd.none)
    RemoveAllFilters ->
        (model, modifyUrl "#")
    UpdateSearchQuery s -> case model of
        Displaying state ->
            (Displaying { state | searchQuery = s }, Cmd.none)
        _ ->
            (Failed "Invalid state", Cmd.none)
    SubmitSearch -> case model of
        Displaying state ->
            let
                query = state.searchQuery ++ " site:ohlasy.info"
                targetURL = "http://www.google.cz/search?q=" ++ (encodeUri query) ++ "&sa=Hledej"
            in
                (model, openURL targetURL)
        _ ->
            (Failed "Invalid state", Cmd.none)
    URLChange location ->
        case model of
            Displaying state ->
                let newSettings = decodeHashStringOrEmpty location.hash
                in (Displaying { state | settings = newSettings }, Cmd.none)
            _ ->
                (Failed "Invalid state", Cmd.none)

downloadArticles : Http.Request String
downloadArticles = Http.getString "http://www.ohlasy.info/api/articles.js"

-- INIT

init : Navigation.Location -> (Model, Cmd Msg)
init location =
    let initialSettings = decodeHashStringOrEmpty location.hash
    in (Loading initialSettings, Http.send ParseArticles downloadArticles)
