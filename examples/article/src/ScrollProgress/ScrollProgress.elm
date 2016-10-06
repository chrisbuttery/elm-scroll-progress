module ScrollProgress exposing (..)

import Html exposing (Html, text, div)
import Html.App as App
import Html.Attributes exposing (style, class)


-- MODEL


type alias Model =
    { progress : Int
    , color : Maybe String
    , from : Maybe String
    , to : Maybe String
    }


type alias ScrollAttributes =
    { scrollTop : Int
    , targetScrollHeight : Int
    , clientHeight : Int
    }


initialModel : Model
initialModel =
    { progress = 0
    , color = Just "red"
    , from = Nothing
    , to = Nothing
    }



-- MESSAGES


type Msg
    = Progress ScrollAttributes



-- UPDATE


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Progress attributes ->
            ( { model | progress = calculateProgress attributes }, Cmd.none )



-- VIEW


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
                [ ( "backgroundColor", color ) ]
            else
                [ ( "backgroundColor", "red" ) ]

        transition =
            [ ( "width", (toString model.progress) ++ "%" )
            , ( "transition", "0.1s width" )
            ]

        styles =
            List.append background transition
    in
        div
            [ class "scroll-progress"
            , style styles
            ]
            []
