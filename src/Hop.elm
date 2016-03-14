module Hop (new) where

{-| A router for single page applications. See [readme](https://github.com/sporto/hop) for usage.

# Setup
@docs new

-}

import History
import Hop.Types exposing (..)
import Hop.Matcher as Matcher


{-| Create a Router

    router =
      Hop.new {
        routes = routes,
        action = Show,
        notFound = NotFound
      }
-}
new : Config actionTag routeTag -> Router actionTag
new config =
  { signal = actionTagSignal config
  , run = History.setPath ""
  }



{-
@private
Each time the hash is changed get a signal
We pass this signal to the main application
-}


actionTagSignal : Config actionTag routeTag -> Signal actionTag
actionTagSignal config =
  Signal.map config.action (routeTagAndQuerySignal config)


routeTagAndQuerySignal : Config actionTag routeTag -> Signal ( routeTag, Query )
routeTagAndQuerySignal config =
  let
    resolve location =
      Matcher.matchLocation config.routes config.notFound location
  in
    Signal.map resolve History.hash