import Html exposing (..)
import Http exposing (send)
import Article exposing (..)
import Json.Decode exposing (decodeString)

main : Program Never Model Msg
main =
  Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
    }

-- MODEL

type Model =
    Loading |
    Displaying (List Article) |
    Failed String

-- UPDATE

type Msg =
    ParseArticles (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ParseArticles (Ok s) ->
            case decodeString articleListDecoder s of
                Err e ->
                    (Failed (toString e), Cmd.none)
                Ok articles ->
                    (Displaying articles, Cmd.none)
        ParseArticles (Err e) ->
            (Failed (toString e), Cmd.none)

downloadArticles : Http.Request String
downloadArticles = Http.getString "http://www.ohlasy.info/api/articles.js"

-- VIEW

view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "Loading…"
        Failed e ->
            text ("Load error: " ++ e)
        Displaying articles ->
            div [] (List.map renderArticle articles)

renderArticle : Article -> Html Msg
renderArticle a = h1 [] [text a.title]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- INIT

init : (Model, Cmd Msg)
init = (Loading, Http.send ParseArticles downloadArticles)
