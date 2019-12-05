module Countries exposing (names, findLocales)




list : List (String, List String)
list =
    [ australia
    , france
    , germany
    , usa
    , unitedKingdom
    ]




names : List String
names =
    list
    |> List.map
        (\ (country, _) -> country)



findLocales : Maybe String -> List String
findLocales maybeCountry =
    case maybeCountry of
        Nothing ->
            []

        Just country ->
            list
            |> List.filter
                (\ (c, _) -> country == c )
            |> List.head
            |> Maybe.withDefault ("", [])
            |> Tuple.second



australia : (String, List String)
australia =
    ( "Australia"
    ,
        [ "New South Wales"
        , "Queensland"
        , "South Australia"
        , "Tasmania"
        , "Victoria"
        , "Western Australia"
        ]
    )


france : (String, List String)
france =
    ( "France"
    ,
        [ "Paris"
        , "Toulouse"
        , "Lyon"
        , "Le Mans"
        , "Nancy"
        ]
    )


germany : (String, List String)
germany =
    ( "Germany"
    ,
        [ "Berlin"
        , "Hamburg"
        , "Bavaria"
        , "Bremen"
        , "Saxony"
        ]
    )


usa : (String, List String)
usa =
    ( "USA"
    ,
        [ "Alabama"
        , "Texas"
        , "Utah"
        , "South Dakota"
        , "Tennessee"
        ]
    )
    

unitedKingdom : (String, List String)
unitedKingdom =
    ( "United Kingdom"
    , 
        [ "Cheshire"
        , "Hampshire"
        , "Lancashire"
        , "Sussex"
        , "Wiltshire"
        ]
    )