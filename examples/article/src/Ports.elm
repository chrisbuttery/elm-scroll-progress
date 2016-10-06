port module Ports exposing (..)

import ScrollProgress exposing (ScrollAttributes)


-- PORTS


port onScroll : (ScrollAttributes -> msg) -> Sub msg
