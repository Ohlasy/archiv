module Main exposing (main)

import Browser
import State
import Views


main =
    Browser.application
        { init = State.init
        , update = State.update
        , subscriptions = \_ -> Sub.none
        , view = Views.rootView
        , onUrlChange = State.UrlChanged
        , onUrlRequest = State.LinkClicked
        }
