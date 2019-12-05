module Main exposing (main)

{-| -}

import Browser
import Countries
import Element exposing (Element, Attribute, centerX, column, el, height, fill, mouseOver, padding, px, rgb, rgb255, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Event
import Element.Font as Font
import Element.Input as Input exposing (Label, Placeholder)
import Html exposing (Html)
import Menu
import Menu.Attributes as Attributes exposing (Attributes)
import Menu.Context as Context
import Menu.Events as Events exposing (Events)


-- Model


init : Model
init =   
    { maybeCountry = Nothing
    , maybeLocale = Nothing
    , maybeActiveElement = Nothing
    , allowBodyToCancelElement = False
    }


type alias Model =
    { maybeCountry : Maybe String
    , maybeLocale : Maybe String
    , maybeActiveElement : Maybe String
    , allowBodyToCancelElement : Bool
    }



-- Update



type Msg
    = CountryChange String
    | CountrySelect String
    | LocaleChange String
    | LocaleSelect String
    | AllowBodyToCancelElement Bool
    | SetActiveElement (Maybe String)



update : Msg -> Model -> Model
update msg model =
    case msg of
        AllowBodyToCancelElement bool ->
            { model | allowBodyToCancelElement = bool }

        SetActiveElement maybeElement ->
            { model | maybeActiveElement = maybeElement }

        CountryChange country ->
            { model
            | maybeCountry = Just country
            , maybeLocale = Nothing
            }

        CountrySelect country ->
            { model
            | maybeCountry = Just country 
            , maybeLocale = Nothing
            , maybeActiveElement = Nothing
            }

        LocaleChange locale ->
            { model | maybeLocale = Just locale }

        LocaleSelect locale ->
            { model
            | maybeLocale = Just locale 
            , maybeActiveElement = Nothing
            }



-- View


view : Model -> Html Msg
view model =
    let
        defaultAttrs =
            [ spacing 10
            , padding 20
            ] 

        attrs =
            case model.allowBodyToCancelElement of
                True ->
                    Event.onMouseDown (SetActiveElement Nothing) :: defaultAttrs

                False ->
                    defaultAttrs

    in  
    Element.layout
        attrs
        <|
            column
                [ spacing 20 ]
                [ el [ centerX ] (text "Countries and Locales")

                , row
                    [ spacing 10
                    , width fill 
                    ]
                    [ countrySelector
                        model.maybeActiveElement
                        model.maybeCountry

                    , localeSelector
                        model.maybeActiveElement
                        model.maybeCountry
                        model.maybeLocale
                    ]
                ]



countrySelector : Maybe String -> Maybe String -> Element Msg
countrySelector maybeActiveElement maybeCountry =
    column
        [ width fill ]
        [ Input.text
            ( textInputAttrs "CountrySelector" )
            ( textInputConfig "Country" CountryChange maybeCountry)

        , Countries.names
            |> menuConfig (Just CountrySelect)
            |> Menu.id (Just "CountrySelector")
            |> Menu.activeId maybeActiveElement
            |> Menu.maybeSelected maybeCountry
            |> Menu.view
        ]



localeSelector : Maybe String -> Maybe String -> Maybe String -> Element Msg
localeSelector maybeActiveElement maybeCountry maybeLocale =
    column
        [ width fill ]
        [ Input.text
            ( textInputAttrs "LocaleSelector" )
            ( textInputConfig "Locale" LocaleChange maybeLocale)

        , maybeCountry
            |> Countries.findLocales
            |> menuConfig (Just LocaleSelect)
            |> Menu.id (Just "LocaleSelector")
            |> Menu.activeId maybeActiveElement
            |> Menu.maybeSelected maybeLocale
            |> Menu.view
        ]




-- Helpers



-- Text Input



textInputAttrs : String -> List (Attribute Msg)
textInputAttrs uiElement =
    [ Event.onFocus (SetActiveElement (Just uiElement))
    , Event.onMouseEnter (AllowBodyToCancelElement False)
    , Event.onMouseLeave (AllowBodyToCancelElement True)
    , Font.size 12
    , width (px 200)
    ]


type alias TextInputConfig msg =
    { onChange : String -> msg
    , text : String
    , placeholder : Maybe (Placeholder msg)
    , label : Label msg
    }


textInputConfig : String -> (String -> Msg) -> Maybe String -> TextInputConfig Msg
textInputConfig label onChange maybeValue =
    { onChange = onChange
    
    , text =
        maybeValue
        |> Maybe.withDefault ""
    
    , placeholder =
        Just (Input.placeholder [] (text label))
    
    , label = Input.labelHidden label
    }   




-- Menu Configs




menuConfig : Maybe (String -> Msg) -> List String -> Menu.Config Msg
menuConfig maybeOnClick options =
    Menu.config
    |> Menu.attributes attributesConfig
    |> Menu.events
        (eventsConfig maybeOnClick)
    |> Menu.options options




attributesConfig : Attributes Msg
attributesConfig =
    Attributes.config
    |> Attributes.column
        [ Background.color (rgb255 173 216 230)
        , Border.glow (rgb255 65 105 225) 3
        ]
    |> Attributes.option
        [ mouseOver
            [ Background.color (rgb255 65 105 225) ]
        , padding 10
        ]
    |> Attributes.selected
        [ Background.color (rgb255 138 43 226) ]




eventsConfig : Maybe (String -> Msg) -> Events Msg
eventsConfig maybeOnClick =
    Events.config
    |> Events.maybeOnMouseEnter (Just (AllowBodyToCancelElement False))
    |> Events.maybeOnClick maybeOnClick
    |> Events.maybeOnMouseLeave (Just (AllowBodyToCancelElement True))




-- Program


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
