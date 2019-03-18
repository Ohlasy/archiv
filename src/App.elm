module Main exposing (main)

import Navigation
import State exposing (..)
import Views exposing (..)


main =
    Navigation.program URLChange
        { init = State.init
        , update = State.update
        , subscriptions = \_ -> Sub.none
        , view = Views.rootView
        }
