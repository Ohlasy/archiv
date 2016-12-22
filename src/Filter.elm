module Filter exposing (..)

import Article exposing (Article)
import Dict exposing (Dict)
import Date exposing (Date)

type alias FilterSettings = Dict String String

type alias Filter = {
    name: String,
    selector: Article -> Maybe String
}

filterArticles : List Article -> Filter -> FilterSettings -> List Article
filterArticles articles f env =
    case Dict.get f.name env of
        Just val -> List.filter (\a ->
            case f.selector a of
                Just x -> x == val
                Nothing -> False) articles
        Nothing -> articles

defaultFilters : List Filter
defaultFilters = [
    { name = "Autor", selector = (Just << .author) },
    { name = "Rubrika", selector = .category },
    { name = "Seriál", selector = .serialID },
    { name = "Rok", selector = (Just << toString << Date.year << .pubDate) }
    ]
