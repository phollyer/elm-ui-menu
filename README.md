# Menu for Elm-UI

This package provides a simple Menu for use with [ Elm-UI ](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/ "The best UI package for Elm").

It is intended to be used as a navigation menu attached to a navigation bar, a searchable list of options, or a [kind of] replacement for the `select` widget that wasn't included in [Elm-UI](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/ "The best UI package for Elm").

The author of Elm-UI chose not to include a `select` widget for good reason, here's a couple of links that should explain why:

1. https://www.joelonsoftware.com/category/uibook/ (See chapter 7)

2. https://boagworld.com/usability/the-country-picker-how-small-things-makes-big-differences

With this in mind, before using this package, please think about your design and whether this package is the right tool to
accomplish your goals.

# Design Goals

This package is intended to simplify the task of Menu creation and provide a consistent approach that can be re-used throughout an Elm application.

It tries to promote [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) by requiring an ID in order to display the menu. If you have multiple menu's and they all have unqiue ID's, then only one menu can be open at a time.

# Usage

Create a `Config` and pass it to the `view` function. The Menu will then decide whether to be open or not based on the `Config`. The `Config` will also determine how the Menu is styled, what `Msg`s are sent to your `update` function, whether the options are sorted, the `Context` the Menu displays as, and which option is currently selected.

The `Config` is an opaque type so use the provided API to build it up using pipelines.

Currently only one level of options is supported.

# Example

The [examples](https://github.com/phollyer/elm-ui-menu/tree/master/examples) are designed so that 'medium' builds in more functionality than 'simple' and 'advanced' builds on 'medium'. The 'simple' examples provide the minimum functionality to view the Menu, and therefore do not behave as completely as you would expect - for example, clicking outside the Menu in the 'simple' examples will not hide the Menu. This is intended behaviour for the examples. 

For complete functionality, check out the 'advanced' examples.

As a learning excercise, you could start off with a 'simple' example, and add your own code to provide the full functionality found in the 'advanced' examples :) .

```Elm
module Main exposing (main)

import Browser
import Element exposing (Element, column, fill, padding, px, text, width)
import Element.Events exposing (onFocus)
import Element.Input as Input
import Html exposing (Html)
import Menu
import Menu.Context as Context
import Menu.Events as Events



-- Model



init : Model
init =   
    { title = Nothing 
    , activeElement = Nothing
    }


type alias Model =
    { title : Maybe String
    , activeElement : Maybe String
    }



-- Update



type Msg
    = TitleChange String
    | TitleSelect String
    | SetActiveElement (Maybe String)



update : Msg -> Model -> Model
update msg model =
    case msg of
        SetActiveElement uiElement ->
            { model | activeElement = uiElement }

        TitleChange title ->
            { model | title = Just title }

        TitleSelect title ->
            { model
            | title = Just title
            , activeElement = Nothing
            }



-- View


view : Model -> Html Msg
view model =
    Element.layout
        [ padding 20 ] 
        ( titleInput 
            model.activeElement
            model.title
        )


titleInput : Maybe String -> Maybe String -> Element Msg
titleInput maybeActiveElement maybeTitle =
    let
        title =
            maybeTitle
            |> Maybe.withDefault ""

    in
    column
        [ width (px 80) ]
        [ Input.text
            [ onFocus (SetActiveElement (Just "TitleSelector")) ]
            { onChange = TitleChange
            
            , text = title
            
            , placeholder =
                Just (Input.placeholder [] (text "Title"))
            
            , label = Input.labelHidden "Title"
            }       

        , Menu.config
            |> Menu.id (Just "TitleSelector")
            |> Menu.activeId maybeActiveElement
            |> Menu.events
                ( Events.config
                    |> Events.maybeOnClick (Just TitleSelect)
                )
            |> Menu.sort False
            |> Menu.maybeSelected maybeTitle
            |> Menu.options
                [ "Mr"
                , "Mrs"
                , "Mx"
                , "Ms"
                , "Miss"
                ]
            |> Menu.view
        ]



-- Program


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
```

# Roadmap

Provide multiple levels of options, specifically for the `Navbar` `Context`.

Provide keyboard navigation, selection and cancellation.

# Credits

[passiomatic](https://discourse.elm-lang.org/t/input-select-not-available-in-elm-ui/2874/5): Links to reading material detailing why `select`s are usually a bad design choice.


