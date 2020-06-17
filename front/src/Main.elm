module Main exposing (Model, Msg(..), init, main, update, view)

-- import Shops.Interface
-- import Shops.Object.ShopType
-- import Http

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)
import Shops.Object
import Shops.Object.CategoryType as Category
import Shops.Object.ProductType as Product
import Shops.Object.ShopType as Shop
import Shops.Query as Query
import Shops.Scalar exposing (Id(..))
import Shops.ScalarCodecs



-- GRAPH_QL
{-
   query {
    shops {
        id
        name
        slug
        products {
            id
            name
            slug
            stock
            price
            category {
                id
                name
                slug
            }
        }
    }
   }
-}


type alias Response =
    List ShopInfo


query : SelectionSet Response RootQuery
query =
    Query.allShops shopSelection


shopSelection : SelectionSet ShopInfo Shops.Object.ShopType
shopSelection =
    SelectionSet.map4 ShopInfo
        Shop.id
        Shop.name
        Shop.slug
        (Shop.products productSelection)


productSelection : SelectionSet ProductInfo Shops.Object.ProductType
productSelection =
    SelectionSet.map6 ProductInfo
        Product.id
        Product.name
        Product.slug
        Product.stock
        Product.price
        (Product.category categorySelection)


categorySelection : SelectionSet CategoryInfo Shops.Object.CategoryType
categorySelection =
    SelectionSet.map3 CategoryInfo
        Category.id
        Category.name
        Category.slug



-- MODEL


type alias Model =
    RemoteData (Graphql.Http.Error Response) Response


type alias ShopInfo =
    { id : Shops.ScalarCodecs.Id
    , name : String
    , slug : String
    , products : List ProductInfo
    }


type alias ProductInfo =
    { id : Shops.ScalarCodecs.Id
    , name : String
    , slug : String
    , stock : Int
    , price : Int
    , category : CategoryInfo
    }


type alias CategoryInfo =
    { id : Shops.ScalarCodecs.Id
    , name : String
    , slug : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )



-- UPDATE


type Msg
    = GotResponse Model


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Shops" ]
        , viewModel model
        ]


viewModel : Model -> Html Msg
viewModel model =
    -- text <| Debug.toString model
    case model of
        NotAsked ->
            text "The shops are not requested yet"

        Success response ->
            viewShops response

        Loading ->
            text "Loading"

        Failure _ ->
            text "Error"


viewShops : Response -> Html Msg
viewShops shops =
    div [] <| List.map viewShop shops


viewShop : ShopInfo -> Html Msg
viewShop shop =
    div []
        [ text <| "Shop «" ++ shop.name ++ "»"
        , ul [] <| List.map viewProduct shop.products
        ]


viewProduct : ProductInfo -> Html Msg
viewProduct product =
    div []
        [ text <| "Product «" ++ product.name ++ "»"
        , text <| "Quantity: " ++ String.fromInt product.stock ++ " items"
        , text <| "Price: " ++ String.fromInt product.price ++ " satoshi"
        , text <| "Category: " ++ product.category.name
        ]



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
