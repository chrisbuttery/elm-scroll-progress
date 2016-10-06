# elm-scroll-progress

Add a scroll progress indicator and track the `scrollTop` position of your app or a specific element.

```shell
elm package install chrisbuttery/elm-scroll-progress
```

### Examples
You can scope to a specific element (e.g. and article) or to the body.

[Article](http://chrisbuttery.github.io/elm-scroll-progress/examples/article/dist/index.html) | [Body](http://chrisbuttery.github.io/elm-scroll-progress/examples/body/dist/index.html)

## Usage

1. Import the module.  
2. Create a new parent Msg type referencing the `ScrollProgress` `Msg`.  
3. Subscribe to an incoming port, ensuring incoming data is passed back to `ScrollProgress.Progress`.  
4. Cater for the ProgressMsg in your `update` function.  
5. Map emitted messages from `ScrollProgress.view` to the type teh parent view expects (Msg).


```elm
module Main exposing (..)
import ScrollProgress exposing (..)

-- MESSAGES

type Msg
    = ProgressMsg ScrollProgress.Msg

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.onScroll (ProgressMsg << ScrollProgress.Progress)

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

--VIEW

view : AppModel -> Html Msg
view model =
    Html.div []
        [ Html.App.map ProgressMsg (ScrollProgress.view model.progressModel)
        , Html.h1 [] [ text "Read this " ]
        , Html.div [] [ text "Some article..." ]
        ]
```

Define an incoming port in your `Ports.elm` so JavaScript can pass in scrolling attributes.

```elm
port module Ports exposing (..)
import ProgressBar exposing (ScrollAttributes)

port onScroll : (ScrollAttributes -> msg) -> Sub msg
```

In your JavaScript, add an eventListener to listen for the "scroll" event on the `window`.  
You can choose to target the document or a specifc element's `targetScrollHeight`.

```js
var app = Elm.Main.embed(root);

var target = document.querySelector('.some-article');
// or target the full page height with:
// target = document.documentElement;

window.addEventListener('scroll', function() {
  app.ports.onScroll.send({
    scrollTop: document.documentElement.scrollTop || document.body.scrollTop,
    targetScrollHeight: target.scrollHeight,
    clientHeight: document.documentElement.clientHeight
  });
});
```
Note: For this to work in Firefox, we need to check for `document.documentElement.scrollTop` otherwise fallback to `document.body.scrollTop`.

## Overrides

All types for defining colors are `Maybe String`.  
By default, the color of the progress scale is defined as `Just ****`, however these `String` values can be whatever CSS colors you wish e.g: `"#336699"`, `"honeydew"`, `"rgba(0,0,0,0.5)"`, etc.

You can choose to overide this color or include a linear gradient.

To override the color of the element, define a new model for the Child inside of the Parent.

```elm
module Main exposing (..)
import ScrollProgress exposing (..)

type alias AppModel =
    { progressModel : ScrollProgress.Model
    }

newChildModel : ScrollProgress.Model
newChildModel =
    { progress = 0
    , color = Just "hotpink"
    , from = Nothing
    , to = Nothing
    }

initialModel : AppModel
initialModel =
    { progressModel = newChildModel }
```

To replace a flat color for a linear gradient, populate the `from` and `to` properties.

```elm
newChildModel : ScrollProgress.Model
newChildModel =
    { progress = 0
    , color = Nothing
    , from = Just "lightseagreen"
    , to = Just "lightsalmon"
    }
```

# Building examples

Install [Create Elm App](https://github.com/halfzebra/create-elm-app) and run `elm-app build` or `elm-app start` inside of `examples/article` & `examples/body`.