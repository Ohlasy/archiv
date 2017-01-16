module State exposing (..)

import Article exposing (..)
import Filter exposing (..)

import Http exposing (send, encodeUri)
import Json.Decode exposing (decodeString)
import Navigation exposing (openURL)
import Dict exposing (Dict)

-- TYPES

type alias DisplayState = {
    articles: List Article,
    filters: List Filter,
    settings: FilterSettings,
    searchQuery: String
}

type Model =
    Loading |
    Displaying DisplayState |
    Failed String

type Msg =
    ParseArticles (Result Http.Error String) |
    UpdateFilterValue Filter (Maybe String) |
    UpdateSearchQuery String |
    SubmitSearch |
    RemoveAllFilters

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    ParseArticles result -> case result of
        Ok s -> case decodeString articleListDecoder s of
            Ok articles ->
                (Displaying (DisplayState articles defaultFilters Dict.empty ""), Cmd.none)
            Err e ->
                (Failed (toString e), Cmd.none)
        Err e ->
            (Failed (toString e), Cmd.none)
    UpdateFilterValue f val -> case model of
        Displaying state ->
            let updatedSettings = case val of
                Just val -> Dict.insert f.name val state.settings
                Nothing -> Dict.remove f.name state.settings
            in (Displaying { state | settings = updatedSettings }, Cmd.none)
        _ ->
            (Failed "Invalid state", Cmd.none)
    RemoveAllFilters -> case model of
        Displaying state ->
            (Displaying { state | settings = Dict.empty }, Cmd.none)
        _ ->
            (Failed "Invalid state", Cmd.none)
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
                (Displaying { state | searchQuery = "" }, openURL targetURL)
        _ ->
            (Failed "Invalid state", Cmd.none)

downloadArticles : Http.Request String
downloadArticles = Http.getString "http://www.ohlasy.info/api/articles.js"

-- INIT

init : (Model, Cmd Msg)
init = (Loading, Http.send ParseArticles downloadArticles)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
