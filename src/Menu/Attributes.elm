module Menu.Attributes exposing
    (Attributes, config
    , column
    , option
    , selected
    )


{-|

# Attributes

The configuration for styling the various parts of the Menu.

@docs Attributes, config

# Example

    { config
    | column =
        [ Background.color (rgb 1 1 1) 
        , Font.color (rgb 0 0 0)
        , Border.glow (rgb 0.9 0.9 0.9) 3
        ]

    , option =
        [ mouseOver
            [ Background.color (rgb 0 0 0) 
            , Font.color (rgb 1 1 1)
            ]
        , padding 5
        ]

    , selected =
        [ Background.color (rgb 0.5 0.5 0.5)]
    }

# Pipeline Helpers

These helpers are the recommended way to build up your [Attributes Config](#Attributes).

# Example

    config
    |> column
        [ Background.color (rgb 1 1 1) 
        , Font.color (rgb 0 0 0)
        , Border.glow (rgb 0.9 0.9 0.9) 3
        ]

    |> option
        [ mouseOver
            [ Background.color (rgb 0 0 0) 
            , Font.color (rgb 1 1 1)
            ]
        , padding 5
        ]

    |> selected
        [ Background.color (rgb 0.5 0.5 0.5)]

@docs column, option, selected
-}

import Element exposing (Attribute, mouseOver, padding, rgb)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


{-| 
-}
type alias Attributes msg =
    { column : List (Attribute msg)
    , option : List (Attribute msg)
    , selected : List (Attribute msg)
    }


{-| Helper function for creating the [Attributes](#Attributes).

Returns an [Attributes](#Attributes) record with the following defaults:

    { column =
        [ Background.color (rgb 1 1 1) 
        , Font.color (rgb 0 0 0)
        , Border.glow (rgb 0.9 0.9 0.9) 3
        ]

    , option =
        [ mouseOver
            [ Background.color (rgb 0 0 0) 
            , Font.color (rgb 1 1 1)
            ]
        , padding 5
        ]
    , selectedOption =
        [ Background.color (rgb 0.5 0.5 0.5)]
    }
-}
config : Attributes msg
config =
    { column =
        [ Background.color (rgb 1 1 1) 
        , Font.color (rgb 0 0 0)
        , Border.glow (rgb 0.9 0.9 0.9) 3
        ]

    , option =
        [ mouseOver
            [ Background.color (rgb 0 0 0) 
            , Font.color (rgb 1 1 1)
            ]
        , padding 5
        ]
    , selected =
        [ Background.color (rgb 0.5 0.5 0.5)]
    }



{-| A list of [Elm-UI Attributes](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) used
for styling the outer [column](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#column) container.
-}
column : List (Attribute msg) -> Attributes msg -> Attributes msg
column col attrs =
    { attrs | column = col }


{-| A list of [Elm-UI Attributes](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) used
for styling each option.
-}
option : List (Attribute msg) -> Attributes msg -> Attributes msg
option opt attrs =
    { attrs | option = opt }


{-| A list of [Elm-UI Attributes](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) used
for styling the currently selected option.
-}
selected : List (Attribute msg) -> Attributes msg -> Attributes msg
selected sel attrs =
    { attrs | selected = sel }
