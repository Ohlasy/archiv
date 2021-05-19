module State exposing (DisplayState, Model(..), Msg(..), init, update)

import Article exposing (..)
import Browser
import Browser.Navigation as Nav
import Dict
import Filter exposing (..)
import Http
import Json.Decode exposing (decodeString)
import Url exposing (Url)
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
    | UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | RemoveAllFilters



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( model, msg ) of
        ( Loading key settings, ParseArticles result ) ->
            case result of
                Ok s ->
                    case decodeString articleListDecoder s of
                        Ok articles ->
                            ( Displaying key (DisplayState articles defaultFilters settings ""), Cmd.none )

                        Err e ->
                            ( Failed (Json.Decode.errorToString e), Cmd.none )

                Err e ->
                    ( Failed "HTTP Error", Cmd.none )

        ( Displaying key state, UpdateFilterValue f val ) ->
            let
                newSettings =
                    updateFilterSettings f state.settings val

                newHash =
                    Url.Builder.custom Url.Builder.Relative [] [] (Just (toString newSettings))
            in
            ( model, Nav.replaceUrl key newHash )

        ( Displaying key state, RemoveAllFilters ) ->
            ( model, Nav.replaceUrl key "#" )

        ( Displaying key state, UpdateSearchQuery newQuery ) ->
            ( Displaying key { state | searchQuery = newQuery }, Cmd.none )

        ( Displaying key state, SubmitSearch ) ->
            ( model, Nav.load (buildSearchUrl state.searchQuery) )

        ( Displaying key state, UrlChanged url ) ->
            let
                newSettings =
                    decodeFilterSettings url
            in
            ( Displaying key { state | settings = newSettings }, Cmd.none )

        ( state, LinkClicked (Browser.External href) ) ->
            ( state, Nav.load href )

        _ ->
            ( Failed "Invalid state", Cmd.none )


buildSearchUrl : String -> String
buildSearchUrl query =
    let
        domainConstrainedQuery =
            query ++ " site:ohlasy.info"
    in
    Url.Builder.crossOrigin
        "https://www.google.cz/"
        [ "search" ]
        [ Url.Builder.string "q" domainConstrainedQuery
        , Url.Builder.string "sa" "Hledej"
        ]


downloadArticles : Cmd Msg
downloadArticles =
    Http.get
        { url = "https://www.ohlasy.info/static-api/articles.js"
        , expect = Http.expectString ParseArticles
        }


decodeFilterSettings : Url -> FilterSettings
decodeFilterSettings url =
    case url.fragment of
        Just fragment ->
            fromString fragment

        Nothing ->
            Dict.empty


updateFilterSettings : Filter -> FilterSettings -> Maybe String -> FilterSettings
updateFilterSettings filter env newValue =
    case newValue of
        Just nonEmpty ->
            Dict.insert filter.slug nonEmpty env

        Nothing ->
            Dict.remove filter.slug env



-- INIT


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialSettings =
            decodeFilterSettings url
    in
    ( Loading key initialSettings, downloadArticles )
