module Menu exposing
    ( view
    , Config, config
    , attributes
    , events
    , context
    , id
    , activeId
    , sort
    , maybeSelected
    , options
    , Position(..), position
    )

{-| 

# Config

The configuration that needs to be passed to [view](#view).

@docs Config

# Example
    
    config
    |> id (Just "SomeId")
    |> activeId (Just "SomeId")
    |> context Context.Select
    |> attributes Attributes.config
    |> events Events.config
    |> sort False
    |> maybeSelected Nothing
    |> options
        [ "List"
        , "Of"
        , "Options"
        ]
    |> view


# API

@docs view, config, id, activeId, options, maybeSelected, context, attributes, events, Position, position, sort
-}

import Element exposing (Element, Attribute, el, column, above, below, pointer, width, fill, text, rgb, mouseOver, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Events exposing (onClick, onMouseEnter, onMouseLeave)

import Menu.Attributes as Attributes exposing (Attributes)
import Menu.Context exposing (Context(..), SearchConfig)
import Menu.Events as Events exposing (Events)



-- MODEL


{-| This is an opaque type, use the API to interact with it.
-}
type Config msg =
    Config
        { attributes : Attributes msg
        , events : Events msg
        , context : Context
        , id : Maybe String
        , activeId : Maybe String
        , sort : Bool
        , maybeSelected : Maybe String
        , options : List String
        , position : Position
        }


{-| The starting point for creating the [Config](#config).
-}
config : Config msg
config =
    Config
        { attributes = Attributes.config
        , events = Events.config
        , context = Select
        , id = Nothing
        , activeId = Nothing
        , sort = True
        , maybeSelected = Nothing
        , options = []
        , position = Below
        }



-- View




{-| The function to render the Menu.

This is a pure function with no side effects, and completely owned by its' parent.

-}
view : Config msg -> Element msg
view (Config conf) =
    case conf.context of
        Select ->
            (Config conf)
            |> selectView [ width fill ]

        Navbar ->
            (Config conf)
            |> navbarView []

        Search searchConfig ->
            (Config conf)
            |> searchView [ width fill ] searchConfig




-- API




{-| This should be unique for each Menu on your page.

It works in conjunction with [activeId](#activeId) in order to display or hide the Menu.

If `id` and `activeId` match, the Menu will display, if they don't, it won't.

If `Nothing` is passed to `id`, the Menu will not display.
-}
id : Maybe String -> Config msg -> Config msg
id id_ (Config conf) =
    Config { conf | id = id_ }


{-| This works in conjunction with [id](#id) in order to display or hide the Menu.

If `activeId` and `id` match, the Menu will display, if they don't, it won't.
-}
activeId : Maybe String -> Config msg -> Config msg
activeId id_ (Config conf) =
    Config { conf | activeId = id_ }


{-| Setting these [Attributes](Menu.Attributes#Attributes) allows you to style
the different components of the Menu.

If not set, defaults to [Attributes.config](Menu.Attributes#config)
-}
attributes : Attributes msg -> Config msg -> Config msg
attributes attrs (Config conf) =
    Config { conf | attributes = attrs }


{-| Setting these [Events](Menu.Events#Events) allows you to respond to various
mouse events in your `update` function.

If not set, defaults to [Events.config](Menu.Events#config)
-}
events : Events msg -> Config msg -> Config msg
events events_ (Config conf) =
    Config { conf | events = events_ }


{-| There are slight nuances in the way the Menu will behave depending on which [Context](#Context) you choose.

See [Context](Menu.Context#Context) for more information.
-}
context : Context -> Config msg -> Config msg
context context_ (Config conf) =
    Config { conf | context = context_ }


{-| Maybe the currently selected option.

If this is set, and matches one of the supplied [options](#options), then the styling
set for [Attributes.selected](Menu.Attributes#selected) will be used to style the
option in the Menu.
-}
maybeSelected : Maybe String -> Config msg -> Config msg
maybeSelected maybeString (Config conf) =
    Config { conf | maybeSelected = maybeString }


{-| The list of options to display.
-}
options : List String -> Config msg -> Config msg
options options_ (Config conf) =
    Config { conf | options = options_ }


{-|
-}
type Position
    = Above
    | Below

{-| The position in which the Menu will display relative to its'
parent.

Will default to `Below` if not set.
-}
position : Position -> Config msg -> Config msg
position pos (Config conf) =
    Config { conf | position = pos }


{-| This determines whether the options should be sorted when displayed.

Internally, the default is to call `List.sort` on the options list.

You only need to set this if you don't require the list to be sorted.

    config
    |> sort False
-}
sort : Bool -> Config msg -> Config msg
sort sort_ (Config conf) =
    Config { conf | sort = sort_ }




-- INTERNAL



-- Views



{-| @priv

Render the select view.
-}
selectView : List (Attribute msg) -> Config msg -> Element msg
selectView attrs (Config conf) =
    conf.options
    |> renderResults attrs (Config conf)


{-| @priv

Render the navbar view.
-}
navbarView : List (Attribute msg) -> Config msg -> Element msg
navbarView attrs (Config conf) =
    conf.options
    |> renderResults attrs (Config conf)


{-| @priv

Render the search results.
-}
searchView : List (Attribute msg) -> SearchConfig -> Config msg -> Element msg
searchView attrs searchConfig (Config conf) =
    let
        conf_ =
            { conf
            | maybeSelected = conf.maybeSelected |> convertEmptyStringToNothing
            }

    in
    case conf_.maybeSelected of
        Just selected ->                    
            conf_.options
            |> List.filter (caseSensitive searchConfig.caseSensitive String.startsWith selected)
            |> List.take searchConfig.maxResults
            |> filterContains searchConfig selected conf_.options
            |> renderResults attrs (Config conf_)

        Nothing ->
            Element.none



{-| @priv

Render the options if id == activeId.
-}
renderResults : List (Attribute msg) -> Config msg -> List String -> Element msg
renderResults attrs (Config conf) options_ =
    case conf.id of
        Nothing ->
            Element.none

        _ ->
            case conf.id == conf.activeId of
                True ->
                    case options_ of
                        [] ->
                            Element.none

                        _ ->
                            options_
                            |> render (Config conf) attrs

                False ->
                    Element.none




{-| @priv

Create the primary element and the column of options.
-}
render : Config msg -> List (Attribute msg) -> List String -> Element msg
render (Config conf) attrs options_ =
    let
        position_ =
            case conf.position of
                Above -> above
                Below -> below

    in
    el
        ( attrs
            |> List.append
                [ position_
                    ( column
                        ( attrs
                            |> List.append conf.attributes.column
                            |> maybeIncludeEvent conf.events.maybeOnMouseEnter onMouseEnter
                            |> maybeIncludeEvent conf.events.maybeOnMouseLeave onMouseLeave
                        )
                        ( options_
                            |> doSort conf.sort
                            |> List.map (renderOption (Config conf))
                        )
                    )
                ]
        )
        ( Element.none )




-- Option




{-| @priv

Create an option element.
-}
renderOption : Config msg -> String -> Element msg
renderOption (Config conf) option =
    let
        attrs =
            conf.attributes
            |> setOptionAttrs option conf.maybeSelected
            |> maybeIncludeOnClick conf.events.maybeOnClick option

    in
    el
        attrs
        (text option)



-- Option Attributes



{-| @priv

Set the Elm-UI attributes for each option.
-}
setOptionAttrs : String -> Maybe String -> Attributes msg -> List (Attribute msg)
setOptionAttrs option maybeSelected_ attrs =
    let
        defaultAttrs =
            pointer
            ::
            (width fill :: attrs.option)

    in
    case maybeSelected_ of
        Just selected ->
            case option == selected of
                True ->
                    attrs.selected
                    |> List.append defaultAttrs

                False ->
                    defaultAttrs

        Nothing ->
            defaultAttrs



-- Search



{-| @priv

If more results are required, filter the options with String.contains, removing any duplicates
and taking the first remainingAmount. Add the extraResults to the current results.
-}
filterContains : SearchConfig -> String -> List String -> List String -> List String
filterContains conf selected options_ results =
    let
        totalResults =
            results
            |> List.length

    in
    case totalResults == conf.maxResults of
        True ->
            results

        False ->
            let
                remainingAmount =
                    conf.maxResults - totalResults

                extraResults =
                    options_
                    |> List.filter (caseSensitive conf.caseSensitive String.contains selected)
                    |> List.filter (duplicate results)
                    |> List.take remainingAmount

            in
            results
            |> List.append extraResults




-- Events




{-| @priv

Add a mouse event to the Elm-UI attributes if required.
-}
maybeIncludeEvent : Maybe msg -> (msg -> Attribute msg) -> List (Attribute msg) -> List (Attribute msg)
maybeIncludeEvent maybeMsg attr attrs =
    case maybeMsg of
        Just msg ->
            (attr msg) :: attrs

        Nothing ->
            attrs




{-| @priv

Add the onClick event to the Elm-UI attributes if required.
-}
maybeIncludeOnClick : Maybe (String -> msg) -> String -> List (Attribute msg) -> List (Attribute msg)
maybeIncludeOnClick maybeOnClick option attrs =
    case maybeOnClick of
        Just onClickMsg ->
            onClick (onClickMsg option)
            :: 
            attrs

        Nothing ->
            attrs




-- General Helpers




{-| @priv

Determine if the option should be kept based on the supplied func, taking
case sensitivity into account.
-}
caseSensitive : Bool -> (String -> String -> Bool) -> String -> String -> Bool
caseSensitive caseSensitive_ func selected option =
    case caseSensitive_ of
        True ->
            option
            |> func selected

        False ->
            option
            |> String.toLower
            |> func
                (selected |> String.toLower)




{-| @priv

Determine if the extraResult already exists in the current list of results.
-}
duplicate : List String -> String -> Bool
duplicate results extraResult =
    results
    |> List.member extraResult
    |> not




{-| @priv

Determine if the options list needs to be sorted, and sort them
if required.
-}
doSort : Bool -> List String -> List String
doSort bool options_ =
    case bool of
        True ->
            options_
            |> List.sort

        False ->
            options_


{-| @priv

Convert an empty String, or a String of just whitespace, to a Nothing.
-}
convertEmptyStringToNothing : Maybe String -> Maybe String
convertEmptyStringToNothing maybeValue =
    case maybeValue of
        Just value ->
            case value |> String.trim of
                "" ->
                    Nothing

                _ ->
                    Just value

        _ -> 
            maybeValue

