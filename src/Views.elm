module Views exposing (..)

import Filter exposing (..)
import Article exposing (..)
import State exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (href)
import List.Extra exposing (unique)

rootView : Model -> Html Msg
rootView model =
    case model of
        Loading ->
            text "Načítám…"
        Failed e ->
            text ("Chyba: " ++ e)
        Displaying articles filters settings ->
            let filteredArticles = applyFilters articles filters settings
            in div [] [
                div [] (List.map (renderFilter articles) filters),
                div [] (List.map renderArticle filteredArticles),
                text ("Celkem článků: " ++ (toString (List.length filteredArticles)))
            ]

applyFilters : List Article -> List Filter -> FilterSettings -> List Article
applyFilters articles filters env =
    case filters of
        fi::xs -> filterArticles (applyFilters articles xs env) fi env
        [] -> articles

renderFilter : List Article -> Filter -> Html Msg
renderFilter articles f =
    let
        noFilterPlaceholder = "bez omezení"
        possibleValues = unique (List.filterMap f.selector articles)
        valueOptions = List.map (\x -> option [] [text x]) possibleValues
        noFilterOption = option [] [text noFilterPlaceholder]
        action tag = if (tag == noFilterPlaceholder)
            then UpdateFilterValue f Nothing
            else UpdateFilterValue f (Just tag)
    in
        div [] [
            text f.name,
            select [onInput action] (noFilterOption :: valueOptions)
        ]

renderArticle : Article -> Html Msg
renderArticle article =
    let absoluteURL = "http://ohlasy.info" ++ article.relativeURL
    in
        a [href absoluteURL] [
            h1 [] [text article.title]
            ]
