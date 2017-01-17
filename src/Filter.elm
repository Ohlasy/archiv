module Filter exposing (..)

import Article exposing (Article)
import Dict exposing (Dict)
import Date

type alias FilterSettings = Dict String String

type alias Filter = {
    name: String,
    slug: String,
    selector: Article -> Maybe String,
    valueDecorator: (String -> String)
}

filterArticles : List Article -> Filter -> FilterSettings -> List Article
filterArticles articles f env =
    case Dict.get f.slug env of
        Just val -> List.filter (\a ->
            case f.selector a of
                Just x -> x == val
                Nothing -> False) articles
        Nothing -> articles

defaultFilters : List Filter
defaultFilters = [
    Filter "Autor" "autor" (Just << .author) identity,
    Filter "Rubrika" "rubrika" .category identity,
    Filter "Seriál" "serial" .serialID serialDecorator,
    Filter "Rok" "rok" (Just << toString << Date.year << .pubDate) identity
    ]

serialDecorator : String -> String
serialDecorator s = case s of
    "ghetto" -> "Příběhy z ghetta"
    "depozitar" -> "Z muzejního depozitáře"
    "krajiny" -> "Krajiny Boskovicka"
    "stromy" -> "Život pod stromy"
    "jazyk" -> "Rendez-vous s jazykem"
    "historie" -> "Pohledy do historie"
    _ -> s