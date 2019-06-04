module Page.SampleView exposing (Model, Msg, init, subscriptions, update, view)

import Env exposing (Env)
import Html exposing (..)
import Json.Decode as JD
import Route
import Url.Parser



-- MODEL


type alias Model =
    { env : Env
    , id : Id
    }


init : Env -> Id -> ( Model, Cmd Msg )
init env id =
    ( Model env id
    , Cmd.none
    )


type Id
    = Id String


idParser : Url.Parser.Parser (Id -> a) a
idParser =
    Url.Parser.custom "ID" (\str -> Just (Id str))


toString : Id -> String
toString (Id id) =
    id


idDecoder : JD.Decoder Id
idDecoder =
    JD.map Id JD.string



-- UPDATE


type Msg
    = NoOps


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOps ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> { title : String, body : List (Html Msg) }
view model =
    { title = "elm-spa-stater - view"
    , body =
        [ a [ Route.href Route.SampleView ] [ text "Back to Index" ]
        , p [] [ text <| "view " ++ toString model.id ]
        ]
    }
