module Question exposing (main)

{-| This module provides a widget for vocabulary questions.

It poses one question at a time, giving the user the possibility to rate their
answer after revealing the right one. The rating is then sent to the server,
and the next question is shown.

The widget maintains an ordered queue of questions that is populated on
initialization and refilled once a configurable threshold is crossed.

@docs main

-}

import Browser
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
    Browser.element
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
    "/ratings/" ++ String.fromInt id ++ ".json"


{-| The URL of the JSON endpoint used for flagging questions.
-}
flagEndpointUrl : Int -> String
flagEndpointUrl id =
    "/learnables/" ++ String.fromInt id ++ "/flag"


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
init flags =
    let
        model =
            { showAnswer = False
            , status = flags.status
            , questions = flags.questions
            , csrfToken = flags.csrfToken
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
                        ( { model | showAnswer = False, questions = [] }
                        , fetchNewQuestions []
                        )

                    first :: rest ->
                        ( { model | showAnswer = False, questions = rest }
                        , Cmd.batch
                            [ fetchNewQuestions model.questions
                            , postRating first rating model.csrfToken
                            ]
                        )

            else
                ( model, Cmd.none )

        ShowSolution ->
            ( { model | showAnswer = True }, Cmd.none )

        FetchQuestions (Ok questions) ->
            ( { model | questions = List.append model.questions questions }, Cmd.none )

        FetchQuestions _ ->
            ( model, Cmd.none )

        PostRating (Ok status_) ->
            ( { model | status = status_ }, Cmd.none )

        PostRating _ ->
            ( model, Cmd.none )

        FlagQuestion id ->
            case model.questions of
                [] ->
                    ( model
                    , fetchNewQuestions []
                    )

                first :: rest ->
                    ( model
                    , Cmd.batch
                        [ fetchNewQuestions model.questions
                        , flagQuestion first model.csrfToken
                        ]
                    )

        QuestionFlagged (Ok question_) ->
            let
                newQuestions =
                    List.map
                        (\q ->
                            if q.id == question_.id then
                                question_

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
            [ ( "number", String.fromInt numberOfQuestionsToFetch )
            , ( "offset", String.fromInt queueLength )
            ]

        queryString =
            queryParams
                |> List.map (\( key, value ) -> key ++ "=" ++ value)
                |> String.join "&"

        url =
            ratingsEndpointUrl ++ "?" ++ queryString

        request =
            Http.get
                { url = url
                , expect = Http.expectJson FetchQuestions decodeQuestions
                }
    in
    if queueLength < minimumNumberOfQuestions then
        request

    else
        Cmd.none


postRating : Question -> Int -> Maybe String -> Cmd Msg
postRating question_ rating csrfToken =
    case csrfToken of
        Just token ->
            let
                url =
                    ratingEndpointUrl question_.id

                params =
                    Encode.object [ ( "rating", Encode.int rating ) ]
            in
            Http.request
                { method = "PUT"
                , headers =
                    [ Http.header "Content-Type" "application/json"
                    , Http.header "X-CSRF-Token" token
                    ]
                , url = url
                , body = Http.jsonBody params
                , expect = Http.expectJson PostRating decodeStatus
                , timeout = Nothing
                , tracker = Nothing
                }

        Nothing ->
            Cmd.none


flagQuestion : Question -> Maybe String -> Cmd Msg
flagQuestion question_ csrfToken =
    case csrfToken of
        Just token ->
            let
                url =
                    flagEndpointUrl question_.id
            in
            Http.request
                { method = "PATCH"
                , headers =
                    [ Http.header "Content-Type" "application/json"
                    , Http.header "X-CSRF-Token" token
                    ]
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson QuestionFlagged decodeQuestion
                , timeout = Nothing
                , tracker = Nothing
                }

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
        [ text (String.fromInt rating) ]


ratingButtons : List (Html Msg)
ratingButtons =
    List.map ratingButton (List.reverse allRatings)


flagButton : Question -> Html Msg
flagButton question_ =
    if question_.flagged then
        p [ class "pull-right" ]
            [ small [] [ text "Enthält möglicherweise Fehler" ]
            ]

    else
        button
            [ class "btn btn-default pull-right"
            , onClick (FlagQuestion question_.id)
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
status model =
    dl [ class "question-info" ]
        [ dt [] [ text "Fragen verbleibend" ]
        , dd [] [ text (String.fromInt model.status.questionsLeftForToday) ]
        , dt [] [ text "Mit Bewertung < 4" ]
        , dd [] [ text (String.fromInt model.status.questionsWithBadRating) ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ question model
        , answer model
        , status model
        ]
