module Main exposing (..)


import Browser
import Html exposing (Html, text, pre)
import Http



-- MAIN

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL  Meningen med "model" er at enkapsulere informationen omkring ens fil som data, vi sætter her forskellige varianter af model som string så de kan
-- sættes senere

type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg) -- Dette beskriver hvordan vores program skal initialiseres, vi skal definerer den startede model og den ønskede command.
init _ = -- vi skriver også her at vi forventer text eller rettere en string
  ( Loading
  , Http.get
      { url = "https://jsonplaceholder.typicode.com/todos/1"
      , expect = Http.expectString GotText
      }
  )


-- UPDATE

type Msg
  = GotText (Result Http.Error String)

-- her bliver vores command feedet ind og bliver håndteret
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)
        Err _ ->
          (Failure, Cmd.none)


-- SUBSCRIPTIONS -- Det er måden man holder elm "opdateret" på hvad som sker i programmet.
-- Hvis man foreksempel vil lytte på information fra en websocket
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW

view : Model -> Html Msg -- View er det som viser vores data "model" og tager højde for variant af model
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]