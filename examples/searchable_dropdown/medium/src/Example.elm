module Main exposing (main)

{-| -}

import Browser
import Element exposing (Element, centerX, column, el, height, fill, padding, px, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Event
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Menu
import Menu.Context as Context
import Menu.Events as Events


-- Model


init : Model
init =   
    { title = Nothing
    , forename = ""
    , activeElement = Nothing
    , allowBodyToCancelElement = False
    }


type alias Model =
    { title : Maybe String
    , forename : String
    , activeElement : Maybe String
    , allowBodyToCancelElement : Bool
    }



-- Update



type Msg
    = TitleChange String
    | TitleSelect String
    | ForenameChange String
    | AllowBodyToCancelElement Bool
    | SetActiveElement (Maybe String)



update : Msg -> Model -> Model
update msg model =
    case msg of
        AllowBodyToCancelElement bool ->
            { model | allowBodyToCancelElement = bool }

        SetActiveElement maybeElement ->
            { model | activeElement = maybeElement }

        TitleChange title ->
            { model | title = Just title }

        TitleSelect title ->
            { model
            | title = Just title 
            , activeElement = Nothing
            }

        ForenameChange forename ->
            { model | forename = forename }



-- View


view : Model -> Html Msg
view model =
    let
        defaultAttrs =
            [ spacing 10
            , padding 20
            , width fill
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
                [ height fill 
                , width fill
                , spacing 20
                ]
                [ el [ centerX ] (text "Personal Details")

                , row
                    [ spacing 10
                    , width fill 
                    ]
                    [ titleInput
                        model.activeElement
                        model.title

                    , forenameInput
                        model.forename
                    ]
                ]


titleInput : Maybe String -> Maybe String -> Element Msg
titleInput activeElement maybeTitle =
    let
        title =
            case maybeTitle of
                Just t -> t
                Nothing -> ""

    in
    column
        [ width (px 80) ]
        [ Input.text
            [ Event.onFocus (SetActiveElement (Just "TitleSelector"))
            , Event.onMouseEnter (AllowBodyToCancelElement False)
            , Event.onMouseLeave (AllowBodyToCancelElement True)
            , Font.size 12
            ]
            { onChange = TitleChange
            
            , text = title
            
            , placeholder =
                Just (Input.placeholder [] (text "Title"))
            
            , label = Input.labelHidden "Title"
            }       

        , Menu.config
            |> Menu.id (Just "TitleSelector")
            |> Menu.activeId activeElement
            |> Menu.events
                ( Events.config
                    |> Events.maybeOnClick (Just TitleSelect)
                    |> Events.maybeOnMouseEnter (Just (AllowBodyToCancelElement False))
                    |> Events.maybeOnMouseLeave (Just (AllowBodyToCancelElement True))
                )
            |> Menu.context 
                (Context.Search Context.searchConfig)
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


forenameInput : String -> Element Msg
forenameInput forename =
    Input.text
        [ Event.onFocus (SetActiveElement (Just "ForenameInput"))
        , Font.size 12
        , width (px 200)
        ]
        { onChange = ForenameChange

        , text = forename
        
        , placeholder =
            Just (Input.placeholder [] (el [] (text "Forename")))
        
        , label = Input.labelHidden "Forename"
        }



-- Program


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
