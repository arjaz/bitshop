module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MODEL


type Model
    = Failure String
    | Loading
    | Success Shops


type alias Shop =
    String


type alias Shops =
    List Shop


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, fetchShops )



-- HTTP


fetchShops : Cmd Msg
fetchShops =
    Http.get
        { url = "http://localhost:8000/api/shops/"
        , expect = Http.expectJson FetchedShops shopsDecoder
        }


shopDecoder : Decoder Shop
shopDecoder =
    field "name" string


shopsDecoder : Decoder Shops
shopsDecoder =
    field "results" (Json.Decode.list shopDecoder)



-- UPDATE


type Msg
    = FetchedShops (Result Http.Error Shops)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchedShops result ->
            case result of
                Ok shops ->
                    ( Success shops, Cmd.none )

                Err err ->
                    case err of
                        Http.BadUrl url ->
                            ( Failure url, Cmd.none )

                        Http.Timeout ->
                            ( Failure "timeout", Cmd.none )

                        Http.NetworkError ->
                            ( Failure "network error", Cmd.none )

                        Http.BadStatus status ->
                            ( Failure (String.fromInt status), Cmd.none )

                        Http.BadBody body ->
                            ( Failure body, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Shops" ]
        , viewShops model
        ]


viewShops : Model -> Html Msg
viewShops model =
    case model of
        Failure err ->
            div [] [ text ("Failed to load shops: " ++ err) ]

        Loading ->
            div [] [ text "Loading..." ]

        Success shops ->
            div [] [ ul [] (List.map (\shop -> li [] [ text shop ]) shops) ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }
