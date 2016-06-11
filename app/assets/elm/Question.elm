module Question exposing (main)

{-| This module provides a widget for vocabulary questions.

It poses one question at a time, giving the user the possibility to rate their
answer after revealing the right one. The rating is then sent to the server,
and the next question is shown.

The widget maintains an ordered queue of questions that is populated on
initialization and refilled once a configurable threshold is crossed.

@docs main
-}

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (id, class)
import Html.Events exposing (onClick)
import Task
import Http
import Json.Decode as Json exposing (..)
import Json.Encode as Encode

{-| The widget is initialized with Rails’ CSRF token and and an initial list of
questions.
-}
main : Program { csrfToken : Maybe String, questions : List Question }
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
minimumNumberOfQuestions = 50

{-| The number of questions to be requested when the queue is refilled.
-}
numberOfQuestionsToFetch : Int
numberOfQuestionsToFetch = 20

{-| All answers get a rating between 1 and 6.
-}
allRatings : List Int
allRatings = [1..6]

{-| The URL of the JSON endpoint used for refilling the queue
-}
ratingsEndpointUrl : String
ratingsEndpointUrl = "/ratings.json"

{-| The URL of the JSON endpoint used for reporting ratings.
-}
ratingEndpointUrl : Int -> String
ratingEndpointUrl id =
  "/ratings/" ++ toString id ++ ".json"

type alias Question =
  { id : Int
  , question : String
  , answer: List String
  }

type alias Model =
  { showAnswer : Bool
  , questions : List Question
  , csrfToken : Maybe String
  }

model : Model
model =
  { showAnswer = False
  , questions = []
  , csrfToken = Nothing
  }

init
  : { csrfToken : Maybe String
    , questions : List Question
    }
  -> (Model, Cmd Msg)
init flags =
  ({ model | csrfToken = flags.csrfToken, questions = flags.questions }, Cmd.none)


-- UPDATE

type Msg
  = RateAnswer Int
  | ShowSolution
  | FetchFail Http.Error
  | FetchSucceed (List Question)
  | PostFail Http.RawError
  | PostSucceed Http.Response

update : Msg -> Model -> (Model, Cmd Msg)
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
                , postRating first rating model.csrfToken ]

      else
        (model, Cmd.none)

    ShowSolution ->
      ({ model | showAnswer = True }, Cmd.none)

    FetchSucceed questions ->
      ({ model | questions = List.append model.questions questions }, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)

    PostSucceed _ ->
      (model, Cmd.none)

    PostFail _ ->
      (model, Cmd.none)

decodeQuestions : Json.Decoder (List Question)
decodeQuestions =
  list decodeQuestion

decodeQuestion : Json.Decoder Question
decodeQuestion =
  object3 Question
    ("id" := int)
    ("question" := string)
    ("answer" := list string)

fetchNewQuestions : (List Question) -> Cmd Msg
fetchNewQuestions questions =
  let
    queueLength = List.length questions

    queryParams =
      [ ( "number", toString numberOfQuestionsToFetch )
      , ( "offset", toString queueLength )
      ]

    url = Http.url ratingsEndpointUrl queryParams

    task = Http.get decodeQuestions url
  in
    if queueLength < minimumNumberOfQuestions then
      Task.perform FetchFail FetchSucceed task
    else
      Cmd.none

postRating : Question -> Int -> Maybe String -> Cmd Msg
postRating question rating csrfToken =
  case csrfToken of
    Just token ->
      let
        url = ratingEndpointUrl question.id

        params =
          Encode.object [ ("rating", Encode.int rating) ]
          |> Encode.encode 0

        task =
          Http.send Http.defaultSettings
            { verb = "PUT"
            , headers = [("X-CSRF-Token", token)]
            , url = url
            , body = Http.string params
            }
      in
        Task.perform PostFail PostSucceed task

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
    , onClick (RateAnswer rating) ]
    [ text (toString rating) ]

ratingButtons : List (Html Msg)
ratingButtons =
  List.map ratingButton (List.reverse allRatings)

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
            , onClick ShowSolution ]
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
          ]
  else
    div [] []

view : Model -> Html Msg
view model =
  div []
    [ question model
    , answer model
    ]
