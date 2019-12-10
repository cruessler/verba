module Question exposing (main)

{-| This module provides a widget for vocabulary questions.

It poses one question at a time, giving the user the possibility to rate their
answer after revealing the right one. The rating is then sent to the server,
and the next question is shown.

The widget maintains an ordered queue of questions that is populated on
initialization and refilled once a configurable threshold is crossed.

@docs main

-}

import Html as Html exposing (..)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Task


{-| The widget is initialized with Rails’ CSRF token and and an initial list of
questions.
-}
main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


{-| The minimum number of questions that should be available in the queue.

When an answer is rated and the length of the queue is less than the number
specified, new questions are loaded asynchronosly.

-}
minimumNumberOfQuestions : Int
minimumNumberOfQuestions =
    50


{-| The number of questions to be requested when the queue is refilled.
-}
numberOfQuestionsToFetch : Int
numberOfQuestionsToFetch =
    20


{-| All answers get a rating between 1 and 6.
-}
allRatings : List Int
allRatings =
    List.range 1 6


{-| The URL of the JSON endpoint used for refilling the queue
-}
ratingsEndpointUrl : String
ratingsEndpointUrl =
    "/ratings.json"


{-| The URL of the JSON endpoint used for reporting ratings.
-}
ratingEndpointUrl : Int -> String
ratingEndpointUrl id =
    "/ratings/" ++ toString id ++ ".json"


{-| The URL of the JSON endpoint used for flagging questions.
-}
flagEndpointUrl : Int -> String
flagEndpointUrl id =
    "/learnables/" ++ toString id ++ "/flag"


type alias Flags =
    { csrfToken : Maybe String
    , questions : List Question
    , status : Status
    }


type alias Status =
    { questionsLeftForToday : Int
    , questionsWithBadRating : Int
    }


type alias Question =
    { id : Int
    , question : String
    , answer : List String
    , flagged : Bool
    }


type alias Model =
    { showAnswer : Bool
    , status : Status
    , questions : List Question
    , csrfToken : Maybe String
    }


init : Flags -> ( Model, Cmd Msg )
init { csrfToken, questions, status } =
    let
        model =
            { showAnswer = False
            , status = status
            , questions = questions
            , csrfToken = csrfToken
            }
    in
    ( model, Cmd.none )



-- UPDATE


type Msg
    = RateAnswer Int
    | ShowSolution
    | FetchQuestions (Result Http.Error (List Question))
    | PostRating (Result Http.Error Status)
    | FlagQuestion Int
    | QuestionFlagged (Result Http.Error Question)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        RateAnswer rating ->
            if rating >= 1 && rating <= 6 then
                case model.questions of
                    [] ->
                        { model | showAnswer = False, questions = [] }
                            ! [ fetchNewQuestions [] ]

                    first :: rest ->
                        { model | showAnswer = False, questions = rest }
                            ! [ fetchNewQuestions model.questions
                              , postRating first rating model.csrfToken
                              ]

            else
                ( model, Cmd.none )

        ShowSolution ->
            ( { model | showAnswer = True }, Cmd.none )

        FetchQuestions (Ok questions) ->
            ( { model | questions = List.append model.questions questions }, Cmd.none )

        FetchQuestions _ ->
            ( model, Cmd.none )

        PostRating (Ok status) ->
            ( { model | status = status }, Cmd.none )

        PostRating _ ->
            ( model, Cmd.none )

        FlagQuestion id ->
            case model.questions of
                [] ->
                    model ! [ fetchNewQuestions [] ]

                first :: rest ->
                    model
                        ! [ fetchNewQuestions model.questions
                          , flagQuestion first model.csrfToken
                          ]

        QuestionFlagged (Ok question) ->
            let
                newQuestions =
                    List.map
                        (\q ->
                            if q.id == question.id then
                                question

                            else
                                q
                        )
                        model.questions
            in
            ( { model | questions = newQuestions }, Cmd.none )

        QuestionFlagged _ ->
            ( model, Cmd.none )


decodeQuestions : Decode.Decoder (List Question)
decodeQuestions =
    Decode.list decodeQuestion


decodeQuestion : Decode.Decoder Question
decodeQuestion =
    Decode.map4 Question
        (field "id" Decode.int)
        (field "question" Decode.string)
        (field "answer" (Decode.list Decode.string))
        (field "flagged" Decode.bool)


decodeStatus : Decode.Decoder Status
decodeStatus =
    Decode.map2 Status
        (field "questionsLeftForToday" Decode.int)
        (field "questionsWithBadRating" Decode.int)


fetchNewQuestions : List Question -> Cmd Msg
fetchNewQuestions questions =
    let
        queueLength =
            List.length questions

        queryParams =
            [ ( "number", toString numberOfQuestionsToFetch )
            , ( "offset", toString queueLength )
            ]

        queryString =
            queryParams
                |> List.map (\( key, value ) -> key ++ "=" ++ value)
                |> String.join "&"

        url =
            ratingsEndpointUrl ++ "?" ++ queryString

        request =
            Http.get url decodeQuestions
    in
    if queueLength < minimumNumberOfQuestions then
        Http.send FetchQuestions request

    else
        Cmd.none


postRating : Question -> Int -> Maybe String -> Cmd Msg
postRating question rating csrfToken =
    case csrfToken of
        Just token ->
            let
                url =
                    ratingEndpointUrl question.id

                params =
                    Encode.object [ ( "rating", Encode.int rating ) ]

                request =
                    Http.request
                        { method = "PUT"
                        , headers =
                            [ Http.header "Content-Type" "application/json"
                            , Http.header "X-CSRF-Token" token
                            ]
                        , url = url
                        , body = Http.jsonBody params
                        , expect = Http.expectJson decodeStatus
                        , timeout = Nothing
                        , withCredentials = False
                        }
            in
            Http.send PostRating request

        Nothing ->
            Cmd.none


flagQuestion : Question -> Maybe String -> Cmd Msg
flagQuestion question csrfToken =
    case csrfToken of
        Just token ->
            let
                url =
                    flagEndpointUrl question.id

                request =
                    Http.request
                        { method = "PATCH"
                        , headers =
                            [ Http.header "Content-Type" "application/json"
                            , Http.header "X-CSRF-Token" token
                            ]
                        , url = url
                        , body = Http.emptyBody
                        , expect = Http.expectJson decodeQuestion
                        , timeout = Nothing
                        , withCredentials = False
                        }
            in
            Http.send QuestionFlagged request

        Nothing ->
            Cmd.none



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


ratingButton : Int -> Html Msg
ratingButton rating =
    button
        [ class "btn btn-default rate-link pull-right"
        , onClick (RateAnswer rating)
        ]
        [ text (toString rating) ]


ratingButtons : List (Html Msg)
ratingButtons =
    List.map ratingButton (List.reverse allRatings)


flagButton : Question -> Html Msg
flagButton question =
    if question.flagged then
        p [ class "pull-right" ]
            [ small [] [ text "Enthält möglicherweise Fehler" ]
            ]

    else
        button
            [ class "btn btn-default pull-right"
            , onClick (FlagQuestion question.id)
            ]
            [ text "Fehler melden" ]


question : Model -> Html Msg
question model =
    case model.questions of
        [] ->
            p [ class "alert alert-info" ]
                [ text "Im Augenblick gibt es nichts mehr zu lernen." ]

        first :: _ ->
            div [ class "row" ]
                [ div [ class "col-md-12" ]
                    [ span [ class "h4" ] [ text first.question ]
                    , a
                        [ id "show-solution"
                        , class "btn btn-default pull-right"
                        , onClick ShowSolution
                        ]
                        [ text "Lösung zeigen" ]
                    ]
                ]


answerLines : List String -> List (Html Msg)
answerLines lines =
    List.map (\line -> div [] [ text line ]) lines


answer : Model -> Html Msg
answer model =
    if model.showAnswer then
        case model.questions of
            [] ->
                div [] []

            first :: _ ->
                div [ id "solution", class "solution" ]
                    [ div [] (answerLines first.answer)
                    , div [ class "row rating" ]
                        [ div [ class "col-md-6" ] [ span [ class "h4" ] [ text "Bewerten" ] ]
                        , div [ class "col-md-6" ] ratingButtons
                        ]
                    , div [ class "row rating" ]
                        [ div [ class "col-md-12" ] [ flagButton first ]
                        ]
                    ]

    else
        div [] []


status : Model -> Html Msg
status { status } =
    dl [ class "question-info" ]
        [ dt [] [ text "Fragen verbleibend" ]
        , dd [] [ text (toString status.questionsLeftForToday) ]
        , dt [] [ text "Mit Bewertung < 4" ]
        , dd [] [ text (toString status.questionsWithBadRating) ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ question model
        , answer model
        , status model
        ]
