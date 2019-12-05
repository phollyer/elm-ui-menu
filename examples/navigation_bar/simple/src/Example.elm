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
                [ column
                    []
                    [ Input.button
                        [ padding 10
                        , Font.size 20
                        ]
                        { onPress = Just (SetActiveElement (Just "MyMenu"))
                        , label =
                            el [] ( text "Open" )
                        }

                    , Menu.config
                        |> Menu.events
                            ( Events.config
                                |> Events.maybeOnClick (Just OptionSelect)
                            )
                        |> Menu.context Context.Navbar
                        |> Menu.id (Just "MyMenu")
                        |> Menu.activeId model.activeElement
                        |> Menu.maybeSelected model.selectedOption
                        |> Menu.options
                            [ "Option 1"
                            , "Option 2"
                            , "Option 3"
                            , "Option 4"
                            , "Option 5"
                            ]
                        |> Menu.view
                    ]
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



-- Program


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
