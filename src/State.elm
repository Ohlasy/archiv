module State exposing (DisplayState, Model(..), Msg(..), init, update)

import Article exposing (..)
import Browser
import Browser.Navigation as Nav
import Dict
import Filter exposing (..)
import Http
import Json.Decode exposing (decodeString)
import URLParsing exposing (decodeHashStringOrEmpty, encodeHashString)
import Url
import Url.Builder



-- TYPES


type alias DisplayState =
    { articles : List Article
    , filters : List Filter
    , settings : FilterSettings
    , searchQuery : String
    }


type Model
    = Loading Nav.Key FilterSettings
    | Displaying Nav.Key DisplayState
    | Failed String


type Msg
    = ParseArticles (Result Http.Error String)
    | UpdateFilterValue Filter (Maybe String)
    | UpdateSearchQuery String
    | SubmitSearch
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | RemoveAllFilters



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model, msg ) of
        -- TODO: Improve error handling
        ( Loading key settings, ParseArticles result ) ->
            case result of
                Ok s ->
                    case decodeString articleListDecoder s of
                        Ok articles ->
                            ( Displaying key (DisplayState articles defaultFilters settings ""), Cmd.none )

                        Err e ->
                            ( Failed "Decoding error", Cmd.none )

                Err e ->
                    ( Failed "HTTP Error", Cmd.none )

        ( Displaying key state, UpdateFilterValue f val ) ->
            let
                newSettings =
                    case val of
                        Just nonEmpty ->
                            Dict.insert f.slug nonEmpty state.settings

                        Nothing ->
                            Dict.remove f.slug state.settings

                newHash =
                    Url.Builder.custom Url.Builder.Relative [] [] (Just (encodeHashString newSettings))
            in
            ( model, Nav.replaceUrl key newHash )

        ( Displaying key state, RemoveAllFilters ) ->
            ( model, Nav.replaceUrl key "#" )

        ( Displaying key state, UpdateSearchQuery newQuery ) ->
            ( Displaying key { state | searchQuery = newQuery }, Cmd.none )

        ( Displaying key state, SubmitSearch ) ->
            let
                query =
                    state.searchQuery ++ " site:ohlasy.info"

                targetURL =
                    Url.Builder.crossOrigin
                        "http://www.google.cz/"
                        [ "search" ]
                        [ Url.Builder.string "q" query, Url.Builder.string "sa" "Hledej" ]
            in
            ( model, Nav.load targetURL )

        ( Displaying key state, UrlChanged location ) ->
            let
                newSettings =
                    Maybe.withDefault Dict.empty
                        (Maybe.map decodeHashStringOrEmpty location.fragment)
            in
            ( Displaying key { state | settings = newSettings }, Cmd.none )

        ( state, LinkClicked (Browser.External href) ) ->
            ( state, Nav.load href )

        _ ->
            ( Failed "Invalid state", Cmd.none )


downloadArticles : Http.Request String
downloadArticles =
    Http.getString "http://www.ohlasy.info/api/articles.js"



-- INIT


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialSettings =
            Maybe.withDefault Dict.empty
                (Maybe.map
                    decodeHashStringOrEmpty
                    url.fragment
                )
    in
    ( Loading key initialSettings, Http.send ParseArticles downloadArticles )
