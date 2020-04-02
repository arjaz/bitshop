module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, string)



-- MODEL


type alias Model =
    { shops : ShopsResult
    }


type ShopsResult
    = ShopsFailure String
    | ShopsLoading
    | ShopsSuccess Shops


type alias Shop =
    { id : Int
    , name : String
    , slug : String
    }


type alias Shops =
    List Shop


init : () -> ( Model, Cmd Msg )
init _ =
    ( { shops = ShopsLoading }, fetchShops )



-- HTTP


fetchShops : Cmd Msg
fetchShops =
    Http.get
        { url = "http://localhost:8000/api/shops/"
        , expect = Http.expectJson FetchedShops shopsDecoder
        }


shopDecoder : Decoder Shop
shopDecoder =
    Json.Decode.map3 Shop (field "id" int) (field "name" string) (field "slug" string)


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
                    ( { shops = ShopsSuccess shops }, Cmd.none )

                Err err ->
                    case err of
                        Http.BadUrl url ->
                            ( { shops = ShopsFailure url }, Cmd.none )

                        Http.Timeout ->
                            ( { shops = ShopsFailure "timeout" }, Cmd.none )

                        Http.NetworkError ->
                            ( { shops = ShopsFailure "network error" }, Cmd.none )

                        Http.BadStatus status ->
                            ( { shops = ShopsFailure (String.fromInt status) }, Cmd.none )

                        Http.BadBody body ->
                            ( { shops = ShopsFailure body }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Shops" ]
        , viewShops model
        ]


viewShops : Model -> Html Msg
viewShops model =
    case model.shops of
        ShopsFailure err ->
            div [] [ text ("Failed to load shops: " ++ err) ]

        ShopsLoading ->
            div [] [ text "ShopsLoading..." ]

        ShopsSuccess shops ->
            div [] [ ul [] (List.map (\shop -> li [] [ text shop ]) (List.map .name shops)) ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }
