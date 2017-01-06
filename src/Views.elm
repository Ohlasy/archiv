module Views exposing (..)

import Filter exposing (..)
import Article exposing (..)
import State exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (unique)
import Date exposing (..)

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
                div [class "resultStats"] [renderResultStats filteredArticles articles],
                div [class "sidebar"] [
                    div [class "search"] [
                        input [type_ "text", placeholder "hledat"] []
                    ],
                    div [class "filters"] (List.map (renderFilter articles) filters)
                ],
                div [class "articles"] (List.map renderArticle filteredArticles)
            ]

applyFilters : List Article -> List Filter -> FilterSettings -> List Article
applyFilters articles filters env =
    case filters of
        fi::xs -> filterArticles (applyFilters articles xs env) fi env
        [] -> articles

renderResultStats : List Article -> List Article -> Html Msg
renderResultStats filtered all =
    let filterCount = List.length filtered
        allCount = List.length all
    in
        text ("nalezených článků: " ++ (toString filterCount) ++ "/" ++ (toString allCount))

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
        div [class "filter"] [
            div [class "filterLabel"] [text f.name],
            select [onInput action] (noFilterOption :: valueOptions)
        ]

renderArticle : Article -> Html Msg
renderArticle article =
    let absoluteURL = "http://ohlasy.info" ++ article.relativeURL
        perex = case article.perex of
            Just s -> s
            Nothing -> ""
    in
        a [href absoluteURL] [
            div [class "article"] [
                h2 [] [text article.title],
                div [class "metadata"] [
                    span [class "author"] [text article.author],
                    text " / ",
                    span [class "pubDate"] [text (renderDate article.pubDate)]
                ],
                p [class "perex"] [text perex]
            ]
        ]

renderDate : Date -> String
renderDate date =
    let d = Date.day date
        y = Date.year date
        s = toString
    in (s d) ++ ". " ++ (localizedMonthName date) ++ " " ++ (s y)

localizedMonthName : Date -> String
localizedMonthName d = case Date.month d of
    Jan -> "ledna"
    Feb -> "února"
    Mar -> "března"
    Apr -> "dubna"
    May -> "května"
    Jun -> "června"
    Jul -> "července"
    Aug -> "srpna"
    Sep -> "září"
    Oct -> "října"
    Nov -> "listopadu"
    Dec -> "prosince"
