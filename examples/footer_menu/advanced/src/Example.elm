module Main exposing (main)

import Browser
import Element exposing (Element, above, alignBottom, centerX, centerY, column, el, height, fill, mouseOver, padding, rgb, rgb255, row, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Event exposing (onFocus)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Menu exposing (Position(..))
import Menu.Context as Context
import Menu.Attributes as Attributes exposing (Attributes)
import Menu.Events as Events exposing (Events)



-- Model



init : Model
init =   
    { selectedOption = Nothing 
    , activeElement = Nothing
    , allowBodyToCancelElement = False
    }


type alias Model =
    { selectedOption : Maybe String
    , activeElement : Maybe String
    , allowBodyToCancelElement : Bool
    }



-- Update



type Msg
    = OptionSelect String
    | SetActiveElement (Maybe String)
    | AllowBodyToCancelElement Bool



update : Msg -> Model -> Model
update msg model =
    case msg of
        AllowBodyToCancelElement bool ->
            { model | allowBodyToCancelElement = bool }

        SetActiveElement uiElement ->
            { model | activeElement = uiElement }

        OptionSelect selectedOption ->
            { model
            | selectedOption = Just selectedOption
            , activeElement = Nothing
            }



-- View



view : Model -> Html Msg
view model =
    let
        defaultAttrs =
            [ width fill ] 

        attrs =
            case model.allowBodyToCancelElement of
                True ->
                    Event.onMouseDown (SetActiveElement Nothing) :: defaultAttrs

                False ->
                    defaultAttrs

    in 
    Element.layout
        attrs
        <| column
            [ height fill
            , width fill
            ]
            [ el
                [ centerX
                , centerY
                , Font.size 40
                ]
                ( text 
                    ( model.selectedOption
                        |> Maybe.withDefault "Nothing Selected"
                    )
                )

            , row
                [ Background.color (rgb 0.5 0.5 0.5)
                , Font.size 22
                , width fill
                , alignBottom
                ]
                [ button1 model.activeElement model.selectedOption
                , button2 model.activeElement model.selectedOption
                , button3 model.activeElement model.selectedOption
                ]
            ]


button1 : Maybe String -> Maybe String -> Element Msg
button1 activeElement selectedOption =
    button (ID "Button1") activeElement "Button 1"
        ( menuConfig
            |> Menu.id (Just "Button1")
            |> Menu.activeId activeElement
            |> Menu.maybeSelected selectedOption
            |> Menu.options
                [ "Button 1:1"
                , "Button 1:2"
                , "Button 1:3"
                , "Button 1:4"
                , "Button 1:5"
                ]
            |> Menu.view
        )


button2 : Maybe String -> Maybe String -> Element Msg
button2 activeElement selectedOption =
    button (ID "Button2") activeElement "Button 2"
        ( menuConfig
            |> Menu.id (Just "Button2")
            |> Menu.activeId activeElement
            |> Menu.maybeSelected selectedOption
            |> Menu.options
                [ "Button 2:1"
                , "Button 2:2"
                , "Button 2:3"
                , "Button 2:4"
                , "Button 2:5"
                ]
            |> Menu.view
        )


button3 : Maybe String -> Maybe String -> Element Msg
button3 activeElement selectedOption =
    button (ID "Button3") activeElement "Button 3"
        ( menuConfig
            |> Menu.id (Just "Button3")
            |> Menu.activeId activeElement
            |> Menu.maybeSelected selectedOption
            |> Menu.options
                [ "Button 3:1"
                , "Button 3:2"
                , "Button 3:3"
                , "Button 3:4"
                , "Button 3:5"
                ]
            |> Menu.view
        )





-- Menu Configs




menuConfig : Menu.Config Msg
menuConfig =
    Menu.config
    |> Menu.attributes attributesConfig
    |> Menu.events
        (eventsConfig (Just OptionSelect))
    |> Menu.context Context.Navbar
    |> Menu.position Above




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




-- Button



type ID
    = ID String



button : ID -> Maybe String -> String -> Element Msg -> Element Msg
button (ID id) activeId label menu =
    let
        elementId =
            case activeId of
                Just id_ ->
                    case id_ == id of
                        True ->
                            Nothing

                        False ->
                            Just id

                Nothing ->
                    Just id
            
    in
    Input.button
        [ above menu
        , padding 10
        , Font.size 20
        ]
        { onPress = Just (SetActiveElement elementId)
        , label =
            el [] ( text label )
        }




-- Program


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
