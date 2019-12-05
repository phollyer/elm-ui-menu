module Menu.Events exposing
    ( Events, config
    , maybeOnClick
    , maybeOnMouseEnter
    , maybeOnMouseLeave
    )

{-|

# Events

The configuration for reacting to mouse events.

@docs Events, config

# Example

    { config
    | maybeOnClick (Just OptionSelected)
    , maybeOnMouseEnter (Just (AllowBodyToCancelElement False))
    , maybeOnMouseLeave (Just (AllowBodyToCancelElement True))
    }

# Pipeline Helpers

These helpers are the recommended way to build up your [Events Config](#Events).

# Example

    config
    |> maybeOnClick (Just OptionSelected)
    |> maybeOnMouseEnter (Just (AllowBodyToCancelElement False))
    |> maybeOnMouseLeave (Just (AllowBodyToCancelElement True))

@docs maybeOnClick, maybeOnMouseEnter, maybeOnMouseLeave
-}





{-| 
-}
type alias Events msg =
    { maybeOnMouseEnter : Maybe msg
    , maybeOnClick : Maybe (String -> msg)
    , maybeOnMouseLeave : Maybe msg
    }




{-| Helper function for creating the [Events](#Events).

Returns a record with the following defaults:

    { maybeOnMouseEnter = Nothing
    , maybeOnClick = Nothing
    , maybeOnMouseLeave = Nothing
    }
-}
config : Events msg
config =
    { maybeOnMouseEnter = Nothing
    , maybeOnClick = Nothing
    , maybeOnMouseLeave = Nothing
    }


{-| The `Msg` to send to your `update` function when the user clicks on an
option in the Menu.
-}
maybeOnClick : Maybe (String -> msg) -> Events msg -> Events msg
maybeOnClick msg conf =
    { conf | maybeOnClick = msg }



{-| The `Msg` to send to your `update` function when the mouse enters the Menu.
-}
maybeOnMouseEnter : Maybe msg -> Events msg -> Events msg
maybeOnMouseEnter msg conf =
    { conf | maybeOnMouseEnter = msg }



{-| The `Msg` to send to your `update` function when the mouse leaves the Menu.
-}
maybeOnMouseLeave : Maybe msg -> Events msg -> Events msg
maybeOnMouseLeave msg conf =
    { conf | maybeOnMouseLeave = msg }