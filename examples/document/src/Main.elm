module Main exposing (..)

import Html exposing (text, Html, div)
import Html.App
import ScrollProgress exposing (..)
import Ports


-- MODEL


type alias AppModel =
    { progressModel : ScrollProgress.Model
    }


initialModel : AppModel
initialModel =
    { progressModel = ScrollProgress.initialModel }


init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGES


type Msg
    = ProgressMsg ScrollProgress.Msg



-- VIEW


view : AppModel -> Html Msg
view model =
    Html.div []
        [ Html.App.map ProgressMsg (ScrollProgress.view model.progressModel) ]



-- UPDATE


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update message model =
    case message of
        ProgressMsg subMsg ->
            let
                ( updatedProgessModel, progressCmd ) =
                    ScrollProgress.update subMsg model.progressModel
            in
                ( { model | progressModel = updatedProgessModel }, Cmd.map ProgressMsg progressCmd )



-- SUBSCIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Ports.onScroll (ProgressMsg << ScrollProgress.Progress)



-- APP


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
