module ScrollProgress exposing (..)

{-| ScrollProgress functions and Msg.

# Model
@docs Model, ScrollAttributes, initialModel

# Message
@docs Msg

# Update function
@docs update, calculateProgress

# View function
@docs view

-}

import Html exposing (Html, text, div)
import Html.App as App
import Html.Attributes exposing (style, class)


{-| A type representing a model.
-}
type alias Model =
    { progress : Int
    , color : Maybe String
    , from : Maybe String
    , to : Maybe String
    }


{-| A type representing the arrtibutes we're expecting 'on scroll'.
-}
type alias ScrollAttributes =
    { scrollTop : Int
    , targetScrollHeight : Int
    , clientHeight : Int
    }


{-| Initalize the model
-}
initialModel : Model
initialModel =
    { progress = 0
    , color = Just "red"
    , from = Nothing
    , to = Nothing
    }


{-| A union type representing The Elm Architect's `Msg`
-}
type Msg
    = Progress ScrollAttributes


{-| A function to calculate the percentage an element has been scrolled
-}
calculateProgress : ScrollAttributes -> Int
calculateProgress attributes =
    let
        scrollTop =
            toFloat attributes.scrollTop

        targetScrollHeight =
            toFloat attributes.targetScrollHeight

        clientHeight =
            toFloat attributes.clientHeight

        progress =
            scrollTop
                / (targetScrollHeight - clientHeight)
                * 100
                |> ceiling
    in
        if progress > 100 then
            100
        else if progress < 0 then
            0
        else
            progress


{-| The Elm Architect's update function.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Progress attributes ->
            ( { model | progress = calculateProgress attributes }, Cmd.none )


{-| A view function that will render the scroll progress ekement.
-}
view : Model -> Html Msg
view model =
    let
        color =
            Maybe.withDefault "" model.color

        from =
            Maybe.withDefault "" model.from

        to =
            Maybe.withDefault "" model.to

        background =
            if color == "" && from /= "" && to /= "" then
                [ ( "background", from )
                , ( "background", "linear-gradient( to right, " ++ from ++ ", " ++ to ++ " )" )
                ]
            else if color /= "" then
                [ ( "background", color ) ]
            else
                [ ( "background", "red" ) ]

        transition =
            [ ( "transition", "0.1s width" )
            , ( "width", (toString model.progress) ++ "%" )
            ]

        styles =
            List.append background transition
    in
        div
            [ class "scroll-progress"
            , style styles
            ]
            []
