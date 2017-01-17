import State exposing (..)
import Views exposing (..)
import Html
import Navigation

main =
    Navigation.program URLChange {
        init = State.init,
        update = State.update,
        subscriptions = (\_ -> Sub.none),
        view = Views.rootView
        }
