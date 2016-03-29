module View (..) where

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, href, style)
import Models exposing (..)
import Actions exposing (..)
import Routing.Utils exposing (reverse)
import Languages.View
import Languages.Models


view : Signal.Address Action -> AppModel -> Html
view address model =
  div
    []
    [ menu address model
    , pageView address model
    ]


menu : Signal.Address Action -> AppModel -> Html
menu address model =
  div
    [ class "p2 white bg-black" ]
    [ div
        []
        [ menuLink address HomeRoute "Home"
        , text "|"
        , menuLink address (LanguagesRoutes Languages.Models.LanguagesRoute) "Languages"
        , text "|"
        , menuLink address AboutRoute "About"
        ]
    ]


menuBtn : Signal.Address Action -> Action -> String -> Html
menuBtn address action label =
  button
    [ Html.Events.onClick address action ]
    [ text label
    ]


menuLink : Signal.Address Action -> Route -> String -> Html
menuLink address route label =
  let
    path =
      reverse route

    action =
      NavigateTo path
  in
    a
      [ href "javascript://"
      , onClick address action
      , class "white px2"
      ]
      [ text label ]


pageView : Signal.Address Action -> AppModel -> Html
pageView address model =
  case model.route of
    HomeRoute ->
      div
        []
        [ h2 [] [ text "Home" ]
        , div [] [ text "Click on Languages to start routing" ]
        ]

    AboutRoute ->
      div
        []
        [ h2 [] [ text "About" ]
        ]

    LanguagesRoutes languagesRoute ->
      let
        viewModel =
          { languages = model.languages
          , route = languagesRoute
          , location = model.location
          }
      in
        Languages.View.view (Signal.forwardTo address LanguagesAction) viewModel

    NotFoundRoute ->
      notFoundView address model


notFoundView : Signal.Address Action -> AppModel -> Html
notFoundView address model =
  div
    []
    [ text "Not Found"
    ]
