module Main exposing (Flags, Model(..), Msg(..), changeRouteTo, init, main, subscriptions, toEnv, update, updateWith, view)

import Browser
import Browser.Navigation as Nav
import Env exposing (Env)
import Html exposing (..)
import Route exposing (Route)
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Model
    = NotFound Env


type alias Flags =
    {}


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    changeRouteTo (Route.fromUrl url)
        (NotFound <|
            Env.create key
        )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url



{- If you want to add a page, add a msg as below.
   ( GotSampleViewMsg subMsg, SampleView \_ id subModel ) ->
   SampleViewPage.update subMsg subModel
   |> updateWith (SampleView env id) GotSampleViewMsg
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    let
        env =
            toEnv model
    in
    case ( message, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case Route.fromUrl url of
                        Just _ ->
                            ( model, Nav.pushUrl (Env.navKey env) (Url.toString url) )

                        Nothing ->
                            ( model, Nav.load <| Url.toString url )

                Browser.External href ->
                    if String.length href == 0 then
                        ( model, Cmd.none )

                    else
                        ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model



{- If you want to add a route, add a case as below.
   Just Route.Index ->
       SampleViewPage.init env
           |> updateWith (Index env) GotSampleViewMsg
-}


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        env =
            toEnv model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound env, Cmd.none )

        Just _ ->
            ( model, Cmd.none )


toEnv : Model -> Env
toEnv page =
    case page of
        NotFound env ->
            env


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS
{- If you want to add a subscription, add a case as below.
   SampleView _ _ subModel ->
       Sub.map GotSampleViewMsg (SampleViewPage.subscriptions subModel)

-}


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        NotFound _ ->
            Sub.none



-- VIEW
{- If you want to add view, add a case as blow.
   SampleView _ _ subModel ->
       viewPage GotSampleViewMsg (SampleViewPage.view subModel)
-}


view : Model -> Browser.Document Msg
view model =
    let
        viewPage toMsg { title, body } =
            { title = title, body = List.map (Html.map toMsg) body }
    in
    case model of
        NotFound _ ->
            { title = "Not Found", body = [ Html.text "Not Found" ] }
