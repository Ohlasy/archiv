import State exposing (..)
import Views exposing (..)
import Html

main : Program Never Model Msg
main =
    Html.program {
        init = State.init,
        update = State.update,
        subscriptions = State.subscriptions,
        view = Views.rootView
        }
