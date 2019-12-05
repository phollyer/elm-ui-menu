module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, column, el, height, fill, padding, rgb, row, shrink, text, width)
import Element.Background as Background
import Element.Events exposing (onFocus)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Menu
import Menu.Context as Context
import Menu.Events as Events



-- Model



init : Model
init =   
    { selectedOption = Nothing 
    , activeElement = Nothing
    }


type alias Model =
    { selectedOption : Maybe String
    , activeElement : Maybe String
    }



-- Update



type Msg
    = OptionSelect String
    | SetActiveElement (Maybe String)



update : Msg -> Model -> Model
update msg model =
    case msg of
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
    Element.layout
        [ width fill ] 
        ( column
            [ height fill
            , width fill
            ]
            [ row
                [ Background.color (rgb 0.5 0.5 0.5)
                , width fill
                ]
                [ button1 model
                , button2 model
                , button3 model
                ]

            , el
                [ centerX
                , centerY
                , Font.size 40
                ]
                ( text 
                    ( model.selectedOption
                        |> Maybe.withDefault "Nothing Selected"
                    )
                )
            ]
        )


button1 : Model -> Element Msg
button1 model =
    column
        []
        [ Input.button
            [ padding 10
            , Font.size 20
            ]
            { onPress = Just (SetActiveElement (Just "Button1"))
            , label =
                el [] ( text "Button 1" )
            }

        , Menu.config
            |> Menu.events
                ( Events.config
                    |> Events.maybeOnClick (Just OptionSelect)
                )
            |> Menu.context Context.Navbar
            |> Menu.id (Just "Button1")
            |> Menu.activeId model.activeElement
            |> Menu.maybeSelected model.selectedOption
            |> Menu.options
                [ "Button 1:1"
                , "Button 1:2"
                , "Button 1:3"
                , "Button 1:4"
                , "Button 1:5"
                ]
            |> Menu.view
        ]


button2 : Model -> Element Msg
button2 model =
    column
        []
        [ Input.button
            [ padding 10
            , Font.size 20
            ]
            { onPress = Just (SetActiveElement (Just "Button2"))
            , label =
                el [] ( text "Button 2" )
            }

        , Menu.config
            |> Menu.events
                ( Events.config
                    |> Events.maybeOnClick (Just OptionSelect)
                )
            |> Menu.context Context.Navbar
            |> Menu.id (Just "Button2")
            |> Menu.activeId model.activeElement
            |> Menu.maybeSelected model.selectedOption
            |> Menu.options
                [ "Button 2:1"
                , "Button 2:2"
                , "Button 2:3"
                , "Button 2:4"
                , "Button 2:5"
                ]
            |> Menu.view
        ]


button3 : Model -> Element Msg
button3 model =
    column
        []
        [ Input.button
            [ padding 10
            , Font.size 20
            ]
            { onPress = Just (SetActiveElement (Just "Button3"))
            , label =
                el [] ( text "Button 3" )
            }

        , Menu.config
            |> Menu.events
                ( Events.config
                    |> Events.maybeOnClick (Just OptionSelect)
                )
            |> Menu.context Context.Navbar
            |> Menu.id (Just "Button3")
            |> Menu.activeId model.activeElement
            |> Menu.maybeSelected model.selectedOption
            |> Menu.options
                [ "Button 3:1"
                , "Button 3:2"
                , "Button 3:3"
                , "Button 3:4"
                , "Button 3:5"
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
