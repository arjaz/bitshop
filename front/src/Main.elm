module Main exposing (Model, Msg(..), init, main, update, view)

-- import Shops.Interface
-- import Shops.Object.ShopType
-- import Http

import Browser
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (..)
import Shops.Mutation as Mutation
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



-- MUTATION


mutation : String -> String -> Int -> Int -> Shops.ScalarCodecs.Id -> SelectionSet (Maybe ()) RootMutation
mutation name slug stock price shopId =
    Mutation.postProduct
        { name = name, slug = slug, stock = stock, price = price, shopId = shopId }
        SelectionSet.empty



-- MODEL


type alias Model =
    { shopsData : RemoteData (Graphql.Http.Error Response) Response
    , productInputName : String
    , productInputSlug : String
    , productInputStock : Int
    , productInputPrice : Int

    -- , productInputShopId : Int
    }


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
    ( { shopsData = RemoteData.Loading
      , productInputName = ""
      , productInputSlug = ""
      , productInputStock = 1
      , productInputPrice = 100
      }
    , makeShopsQueryRequest
    )



-- UPDATE


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error Response) Response)
    | GotProductPostResponse (RemoteData (Graphql.Http.Error (Maybe ())) (Maybe ()))
    | ChangeProductName String
    | ChangeProductSlug String
    | ChangeProductStock Int
    | ChangeProductPrice Int
    | PostProduct Shops.ScalarCodecs.Id


makeShopsQueryRequest : Cmd Msg
makeShopsQueryRequest =
    query
        |> Graphql.Http.queryRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


makeProductPostRequest : String -> String -> Int -> Int -> Shops.ScalarCodecs.Id -> Cmd Msg
makeProductPostRequest name slug stock price shopId =
    mutation name slug stock price shopId
        |> Graphql.Http.mutationRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotProductPostResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( { model | shopsData = response }, Cmd.none )

        GotProductPostResponse _ ->
            ( model, Cmd.none )

        ChangeProductName name ->
            ( { model | productInputName = name }, Cmd.none )

        ChangeProductSlug slug ->
            ( { model | productInputSlug = slug }, Cmd.none )

        ChangeProductStock amount ->
            ( { model | productInputStock = amount }, Cmd.none )

        ChangeProductPrice price ->
            ( { model | productInputPrice = price }, Cmd.none )

        PostProduct shopId ->
            ( { model | productInputName = "", productInputSlug = "", productInputStock = 1, productInputPrice = 100 }, makeProductPostRequest model.productInputName model.productInputSlug model.productInputStock model.productInputPrice shopId )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Shops" ]
        , viewModel model
        ]


viewModel : Model -> Html Msg
viewModel model =
    case model.shopsData of
        NotAsked ->
            text "The shops are not requested yet"

        Success response ->
            viewShops model response

        Loading ->
            text "Loading"

        Failure _ ->
            text "Error"


viewShops : Model -> Response -> Html Msg
viewShops model shops =
    ul [ class "shops-list" ] <| List.map (viewShop model) shops


viewShop : Model -> ShopInfo -> Html Msg
viewShop model shop =
    div [ class "shop-card" ]
        [ text <| "Shop «" ++ shop.name ++ "»"
        , ul [ class "products-list" ] <| List.map viewProduct shop.products
        , viewProductForm model shop.id
        ]


viewProduct : ProductInfo -> Html Msg
viewProduct product =
    div []
        [ div [ class "product-name" ] [ text <| "Product «" ++ product.name ++ "»" ]
        , div [ class "product-stock" ] [ text <| "Quantity: " ++ String.fromInt product.stock ++ " items" ]
        , div [ class "product-price" ] [ text <| "Price: " ++ String.fromInt product.price ++ " satoshi" ]
        , div [ class "category-name" ] [ text <| "Category: " ++ product.category.name ]
        ]


viewProductForm : Model -> Shops.ScalarCodecs.Id -> Html Msg
viewProductForm model shopId =
    div [ class "product-form" ]
        [ viewInput "text" "Product name" model.productInputName ChangeProductName
        , viewInput "text" "Product slug" model.productInputSlug ChangeProductSlug
        , viewInput "text" "Product stock" (String.fromInt model.productInputStock) (String.toInt >> Maybe.withDefault 0 >> ChangeProductStock)
        , viewInput "text" "Product price" (String.fromInt model.productInputPrice) (String.toInt >> Maybe.withDefault 0 >> ChangeProductPrice)
        , button [ onClick <| PostProduct shopId ] [ text "Submit" ]
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input
        [ type_ t
        , placeholder p
        , value v
        , onInput toMsg
        ]
        []



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
