module Views exposing (..)

import Filter exposing (..)
import Article exposing (..)
import State exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (unique)
import Date exposing (..)
import Dict

rootView : Model -> Html Msg
rootView model = case model of
    Loading _ ->
        div [class "status"] [text "Načítám…"]
    Failed e ->
        div [class "status"] [text ("Chyba: " ++ e)]
    Displaying state ->
        let
            { articles, filters, settings, searchQuery } = state
            filteredArticles = applyFilters articles filters settings
        in div [] [
            renderResultStats filteredArticles articles,
            renderSidebar articles filters settings,
            renderArticles filteredArticles
        ]

-- Result Statistics

renderResultStats : List Article -> List Article -> Html Msg
renderResultStats filtered all =
    let filterCount = List.length filtered
        allCount = List.length all
    in
        div [class "status"] [
            text ("nalezených článků: " ++ (toString filterCount) ++ "/" ++ (toString allCount))
        ]

-- Sidebar

renderSidebar : List Article -> List Filter -> FilterSettings -> Html Msg
renderSidebar articles filters settings =
    div [class "sidebar"] [
        div [class "search"] [
            Html.form [onSubmit SubmitSearch] [
                input [type_ "text", placeholder "hledat", onInput (\s -> UpdateSearchQuery s)] [],
                input [type_ "submit", hidden True] []
            ]
        ],
        div [class "filters"] (renderFilterControls articles filters settings)
    ]

renderFilterControls : List Article -> List Filter -> FilterSettings -> List (Html Msg)
renderFilterControls articles filters settings =
     (List.map (renderFilter articles settings) filters) ++
         [button [onClick RemoveAllFilters, disabled (Dict.isEmpty settings)] [text "Smazat filtry"]]

renderFilter : List Article -> FilterSettings -> Filter -> Html Msg
renderFilter articles settings f =
    let
        noFilterPlaceholder = "bez omezení"
        currentValue = Dict.get f.slug settings
        possibleValues = unique (List.filterMap f.selector articles)
        valueOptions = List.map (\x -> option [value x, selected (currentValue == Just x)] [text (f.valueDecorator x)]) possibleValues
        noFilterOption = option [selected (currentValue == Nothing)] [text noFilterPlaceholder]
        action tag = if (tag == noFilterPlaceholder)
            then UpdateFilterValue f Nothing
            else UpdateFilterValue f (Just tag)
    in
        div [class "filter"] [
            div [class "filterLabel"] [text f.name],
            select [onInput action] (noFilterOption :: valueOptions)
        ]

-- Articles

renderArticles : List Article -> Html Msg
renderArticles articles =
    div [class "articles"] (List.map renderArticle articles)

applyFilters : List Article -> List Filter -> FilterSettings -> List Article
applyFilters articles filters env =
    case filters of
        fi::xs -> filterArticles (applyFilters articles xs env) fi env
        [] -> articles

renderArticle : Article -> Html Msg
renderArticle article =
    let absoluteURL = "http://ohlasy.info" ++ article.relativeURL
        perex = case article.perex of
            Just s -> s
            Nothing -> ""
    in
        a [href absoluteURL] [
            div [class "article-wrapper"] [
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
