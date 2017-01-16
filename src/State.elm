module State exposing (..)

import Article exposing (..)
import Filter exposing (..)

import Http exposing (send)
import Json.Decode exposing (decodeString)
import Dict exposing (Dict)

-- TYPES

type Model =
    Loading |
    Displaying (List Article) (List Filter) FilterSettings |
    Failed String

type Msg =
    ParseArticles (Result Http.Error String) |
    UpdateFilterValue Filter (Maybe String) |
    RemoveAllFilters

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
    ParseArticles result -> case result of
        Ok s -> case decodeString articleListDecoder s of
            Ok articles ->
                (Displaying articles defaultFilters Dict.empty, Cmd.none)
            Err e ->
                (Failed (toString e), Cmd.none)
        Err e ->
            (Failed (toString e), Cmd.none)
    UpdateFilterValue f val -> case model of
        Displaying articles filters settings ->
            let updatedSettings = case val of
                Just val -> Dict.insert f.name val settings
                Nothing -> Dict.remove f.name settings
            in (Displaying articles filters updatedSettings, Cmd.none)
        _ ->
            (Failed "Invalid state", Cmd.none)
    RemoveAllFilters -> case model of
        Displaying articles filters settings ->
            (Displaying articles filters Dict.empty, Cmd.none)
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
