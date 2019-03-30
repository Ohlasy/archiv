module Views exposing (rootView)

import Article exposing (..)
import Browser
import Dict
import Filter exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error)
import List.Extra exposing (unique)
import State exposing (..)
import Time


rootView : Model -> Browser.Document Msg
rootView model =
    case model of
        Loading _ _ ->
            { title = "Načítám…"
            , body =
                [ img [ src "spinner.gif", class "spinner" ] []
                ]
            }

        Failed e ->
            buildPage <| div [ class "status" ] [ text ("Chyba: " ++ e) ]

        Displaying _ state ->
            let
                { articles, filters, settings, searchQuery } =
                    state

                filteredArticles =
                    applyFilters articles filters settings
            in
            buildPage <|
                div []
                    [ renderResultStats filteredArticles articles
                    , renderSidebar articles filters settings
                    , renderArticles filteredArticles
                    ]


buildPage : Html Msg -> Browser.Document Msg
buildPage content =
    { title = "Archiv článků"
    , body =
        [ div [ class "header" ]
            [ h1 []
                [ text "Ohlasy\u{00A0}"
                , small [] [ text "Archiv článků" ]
                ]
            ]
        , content
        ]
    }



-- Result Statistics


renderResultStats : List Article -> List Article -> Html Msg
renderResultStats filtered all =
    let
        filterCount =
            List.length filtered

        allCount =
            List.length all
    in
    div [ class "status" ]
        [ text ("nalezených článků: " ++ String.fromInt filterCount ++ "/" ++ String.fromInt allCount)
        ]



-- Sidebar


renderSidebar : List Article -> List Filter -> FilterSettings -> Html Msg
renderSidebar articles filters settings =
    div [ class "sidebar" ]
        [ div [ class "search" ]
            [ Html.form [ onSubmit SubmitSearch ]
                [ input [ type_ "text", placeholder "hledat", onInput (\s -> UpdateSearchQuery s) ] []
                , input [ type_ "submit", hidden True ] []
                ]
            ]
        , div [ class "filters" ] (renderFilterControls articles filters settings)
        ]


renderFilterControls : List Article -> List Filter -> FilterSettings -> List (Html Msg)
renderFilterControls articles filters settings =
    List.map (renderFilter articles settings) filters
        ++ [ button [ onClick RemoveAllFilters, disabled (Dict.isEmpty settings) ] [ text "Smazat filtry" ] ]


renderFilter : List Article -> FilterSettings -> Filter -> Html Msg
renderFilter articles settings f =
    let
        noFilterPlaceholder =
            "bez omezení"

        currentValue =
            Dict.get f.slug settings

        possibleValues =
            articles
                |> List.concatMap f.selector
                |> unique
                |> List.sortWith f.sort

        valueOptions =
            List.map (\x -> option [ value x, selected (currentValue == Just x) ] [ text (f.valueDecorator x) ]) possibleValues

        noFilterOption =
            option [ selected (currentValue == Nothing) ] [ text noFilterPlaceholder ]

        action tag =
            if tag == noFilterPlaceholder then
                UpdateFilterValue f Nothing

            else
                UpdateFilterValue f (Just tag)
    in
    div [ class "filter" ]
        [ div [ class "filterLabel" ] [ text f.name ]
        , select [ onInput action ] (noFilterOption :: valueOptions)
        ]



-- Articles


renderArticles : List Article -> Html Msg
renderArticles articles =
    div [ class "articles" ] (List.map renderArticle articles)


applyFilters : List Article -> List Filter -> FilterSettings -> List Article
applyFilters articles filters env =
    case filters of
        fi :: xs ->
            filterArticles fi env (applyFilters articles xs env)

        [] ->
            articles


renderArticle : Article -> Html Msg
renderArticle article =
    let
        absoluteURL =
            "http://ohlasy.info" ++ article.relativeURL

        perex =
            Maybe.withDefault "" article.perex
    in
    a [ href absoluteURL ]
        [ div [ class "article-wrapper" ]
            [ div [ class "article" ]
                [ h2 [] [ text article.title ]
                , div [ class "metadata" ]
                    [ span [ class "author" ] [ text article.author ]
                    , text "\u{00A0}/\u{00A0}"
                    , span [ class "pubDate" ] [ text (renderDate article.pubDate) ]
                    ]
                , p [ class "perex" ] [ text perex ]
                ]
            ]
        ]


renderDate : Time.Posix -> String
renderDate date =
    let
        tz =
            Time.utc

        d =
            Time.toDay tz date

        y =
            Time.toYear tz date

        s =
            String.fromInt
    in
    s d ++ ". " ++ localizedMonthName date ++ " " ++ s y


localizedMonthName : Time.Posix -> String
localizedMonthName d =
    case Time.toMonth Time.utc d of
        Time.Jan ->
            "ledna"

        Time.Feb ->
            "února"

        Time.Mar ->
            "března"

        Time.Apr ->
            "dubna"

        Time.May ->
            "května"

        Time.Jun ->
            "června"

        Time.Jul ->
            "července"

        Time.Aug ->
            "srpna"

        Time.Sep ->
            "září"

        Time.Oct ->
            "října"

        Time.Nov ->
            "listopadu"

        Time.Dec ->
            "prosince"
