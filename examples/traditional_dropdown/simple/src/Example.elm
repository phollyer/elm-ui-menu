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
