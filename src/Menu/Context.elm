module Menu.Context exposing
    (Context(..)
    , SearchConfig, searchConfig
    , caseSensitive, maxResults
    )

{-| The context the Menu operates from.

There are three options:

1. A 'traditional' dropdown menu that provides a list of options to select.
2. A menu intended to be used in conjunction with a navigation bar.
3. A filtered list of 'n' options.

@docs Context

# Search

The [Search Context](#Context) requires some configuration.

@docs SearchConfig, searchConfig

# Pipeline Helpers

These helpers are the recommended way to build up your [SearchConfig](#SearchConfig).

# Example

    searchConfig
    |> caseSensitive True
    |> maxResults 10

@docs caseSensitive, maxResults

-}


{-| There are slight nuances in the way the Menu will behave depending on which [Context](#Context) you choose.

1. Select: This will display a full list of [options](Select#options) and will size its' width to equal its' parent.
2. Navbar: This will display a full list of [options](Select#options) and will size its' width to equal its' contents.
3. Search: This will display a filtered list of [options](Select#options) based on the string supplied to [maybeSelected](Select#maybeSelected),
and will size its' width to equal its' parent.

-}
type Context
    = Select
    | Navbar
    | Search SearchConfig



{-|
-}
type alias SearchConfig =
    { caseSensitive : Bool
    , maxResults : Int
    }



{-| Helper function for setting the [SearchConfig](#SearchConfig).
Returns a [SearchConfig](#SearchConfig) record, with the following defaults:
    
    { caseSensitive = False
    , maxResults = 5
    }
-}
searchConfig : SearchConfig
searchConfig =
    { caseSensitive = False
    , maxResults = 5
    }


{-| Determines if the search filter is case sensitive.

If this is not set, it will default to `False`.
-}
caseSensitive : Bool -> SearchConfig -> SearchConfig
caseSensitive bool conf =
    { conf | caseSensitive = bool }


{-| Determines the maximum number of results to return.

If this is not set, it will default to 5.

There is no special algorithm to determine which results are returned if there are
more available than [maxResults](#maxResults) requires.

Internally, the filtering goes like this:

    options
    |> filter with String.startsWith
    |> List.take maxResults
    |> filter with String.contains if more results are required
-}
maxResults : Int -> SearchConfig -> SearchConfig
maxResults max conf =
    { conf | maxResults = max }