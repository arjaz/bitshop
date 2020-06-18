module Main exposing (Model, Msg(..), init, main, update, view)

-- import Shops.Interface
-- import Shops.Object.ShopType
-- import Http

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Grid as Grid
import Browser
import Dict exposing (Dict)
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
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


postProductMutation : String -> String -> Int -> Int -> Shops.ScalarCodecs.Id -> SelectionSet (Maybe ()) RootMutation
postProductMutation name slug stock price shopId =
    Mutation.postProduct
        { name = name, slug = slug, stock = stock, price = price, shopId = shopId }
        SelectionSet.empty


buyProductMutation : Shops.ScalarCodecs.Id -> SelectionSet (Maybe ()) RootMutation
buyProductMutation id =
    Mutation.buyProduct { id = id }
        SelectionSet.empty


postShopMutation : String -> String -> SelectionSet (Maybe ()) RootMutation
postShopMutation name slug =
    Mutation.postShop
        { name = name, slug = slug }
        SelectionSet.empty



-- MODEL


type alias Model =
    { shopsData : RemoteData (Graphql.Http.Error Response) Response
    , productInputs :
        Dict String
            { name : String
            , slug : String
            , stock : Int
            , price : Int
            }
    , shopInput :
        Maybe
            { name : String
            , slug : String
            }
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
      , productInputs = Dict.empty
      , shopInput = Nothing
      }
    , makeShopsQueryRequest
    )



-- UPDATE


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error Response) Response)
    | GotProductPostResponse (RemoteData (Graphql.Http.Error (Maybe ())) (Maybe ()))
    | GotProductBuyResponse (RemoteData (Graphql.Http.Error (Maybe ())) (Maybe ()))
    | GotShopPostResponse (RemoteData (Graphql.Http.Error (Maybe ())) (Maybe ()))
    | ChangeProductName String String
    | ChangeProductSlug String String
    | ChangeProductStock String Int
    | ChangeProductPrice String Int
    | ChangeShopName String
    | ChangeShopSlug String
    | PostShop
    | PostProduct Shops.ScalarCodecs.Id
    | BuyProduct ProductInfo


makeShopsQueryRequest : Cmd Msg
makeShopsQueryRequest =
    query
        |> Graphql.Http.queryRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


makeProductPostRequest : String -> String -> Int -> Int -> Shops.ScalarCodecs.Id -> Cmd Msg
makeProductPostRequest name slug stock price shopId =
    postProductMutation name slug stock price shopId
        |> Graphql.Http.mutationRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotProductPostResponse)


makeProductBuyRequest : Shops.ScalarCodecs.Id -> Cmd Msg
makeProductBuyRequest id =
    buyProductMutation id
        |> Graphql.Http.mutationRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotProductBuyResponse)


makeShopPostRequest : String -> String -> Cmd Msg
makeShopPostRequest name slug =
    postShopMutation name slug
        |> Graphql.Http.mutationRequest "http://127.0.0.1:8000/graphql/"
        |> Graphql.Http.send (RemoteData.fromResult >> GotShopPostResponse)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( { model | shopsData = response }, Cmd.none )

        GotProductPostResponse _ ->
            ( model, makeShopsQueryRequest )

        GotProductBuyResponse _ ->
            ( model, makeShopsQueryRequest )

        GotShopPostResponse _ ->
            ( model, makeShopsQueryRequest )

        ChangeProductName shopIdString name ->
            ( { model
                | productInputs =
                    Dict.update
                        shopIdString
                        (\maybeProduct ->
                            case maybeProduct of
                                Nothing ->
                                    Just { name = name, slug = "", stock = 0, price = 0 }

                                Just product ->
                                    Just { product | name = name }
                        )
                        model.productInputs
              }
            , Cmd.none
            )

        ChangeProductSlug shopIdString slug ->
            ( { model
                | productInputs =
                    Dict.update
                        shopIdString
                        (\maybeProduct ->
                            case maybeProduct of
                                Nothing ->
                                    Just { name = "", slug = slug, stock = 0, price = 0 }

                                Just product ->
                                    Just { product | slug = slug }
                        )
                        model.productInputs
              }
            , Cmd.none
            )

        ChangeProductStock shopIdString amount ->
            ( { model
                | productInputs =
                    Dict.update
                        shopIdString
                        (\maybeProduct ->
                            case maybeProduct of
                                Nothing ->
                                    Just { name = "", slug = "", stock = amount, price = 0 }

                                Just product ->
                                    Just { product | stock = amount }
                        )
                        model.productInputs
              }
            , Cmd.none
            )

        ChangeProductPrice shopIdString price ->
            ( { model
                | productInputs =
                    Dict.update
                        shopIdString
                        (\maybeProduct ->
                            case maybeProduct of
                                Nothing ->
                                    Just { name = "", slug = "", stock = 0, price = price }

                                Just product ->
                                    Just { product | price = price }
                        )
                        model.productInputs
              }
            , Cmd.none
            )

        ChangeShopName name ->
            let
                oldInput =
                    model.shopInput

                newInput =
                    case oldInput of
                        Nothing ->
                            Just { name = name, slug = "" }

                        Just shopInput ->
                            Just { shopInput | name = name }
            in
            ( { model | shopInput = newInput }, Cmd.none )

        ChangeShopSlug slug ->
            let
                oldInput =
                    model.shopInput

                newInput =
                    case oldInput of
                        Nothing ->
                            Just { name = "", slug = slug }

                        Just shopInput ->
                            Just { shopInput | slug = slug }
            in
            ( { model | shopInput = newInput }, Cmd.none )

        PostShop ->
            let
                shopName =
                    model.shopInput |> Maybe.map .name |> Maybe.withDefault ""

                shopSlug =
                    model.shopInput |> Maybe.map .slug |> Maybe.withDefault ""
            in
            ( { model | shopInput = Nothing }, makeShopPostRequest shopName shopSlug )

        PostProduct ((Id shopIdString) as shopId) ->
            ( { model | productInputs = Dict.update shopIdString (\_ -> Just { name = "", slug = "", stock = 1, price = 100 }) model.productInputs }
            , makeProductPostRequest
                (Maybe.withDefault "" <| Maybe.map .name (Dict.get shopIdString model.productInputs))
                (Maybe.withDefault "" <| Maybe.map .slug (Dict.get shopIdString model.productInputs))
                (Maybe.withDefault 0 <| Maybe.map .stock (Dict.get shopIdString model.productInputs))
                (Maybe.withDefault 0 <| Maybe.map .price (Dict.get shopIdString model.productInputs))
                shopId
            )

        BuyProduct product ->
            ( model, makeProductBuyRequest product.id )



-- VIEW


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , viewModel model
        , viewShopForm model
        ]


viewModel : Model -> Html Msg
viewModel model =
    case model.shopsData of
        NotAsked ->
            Card.config []
                |> Card.block [] [ Block.text [] [ text "The shops are not requested yet" ] ]
                |> Card.view

        Success response ->
            viewShops model response

        Loading ->
            Card.config []
                |> Card.block [] [ Block.text [] [ text "The shops are loading..." ] ]
                |> Card.view

        Failure _ ->
            Card.config []
                |> Card.block [] [ Block.text [] [ text "Error" ] ]
                |> Card.view


viewShops : Model -> Response -> Html Msg
viewShops model shops =
    ul [ class "shops-list" ] <| List.map (viewShop model) shops


viewShop : Model -> ShopInfo -> Html Msg
viewShop model shop =
    Card.config [ Card.attrs [ class "mt-4" ] ]
        |> Card.header [ class "text-center " ] [ h2 [] [ text <| "Shop «" ++ shop.name ++ "»" ] ]
        |> Card.block []
            [ Block.custom << Card.columns <| List.map viewProduct shop.products
            , Block.custom <|
                viewProductForm
                    model
                    shop.id
            ]
        |> Card.view


viewShopForm : Model -> Html Msg
viewShopForm model =
    div [ class "shop-form text-center p-10" ]
        [ viewInput "text" "Shop name" (model.shopInput |> Maybe.map .name |> Maybe.withDefault "") ChangeShopName
        , viewInput "text" "Shop slug" (model.shopInput |> Maybe.map .slug |> Maybe.withDefault "") ChangeShopSlug
        , button [ onClick PostShop ] [ text "Add shop" ]
        ]


viewProduct : ProductInfo -> Card.Config Msg
viewProduct product =
    Card.config [ Card.attrs [ class "mt-4" ] ]
        |> Card.header [ class "text-center" ] [ h3 [] [ text <| "Product «" ++ product.name ++ "»" ] ]
        |> Card.block []
            [ Block.text [] [ text <| "Quantity: " ++ String.fromInt product.stock ++ " items" ]
            , Block.text [] [ text <| "Price: " ++ String.fromInt product.price ++ " satoshi" ]
            , Block.custom <|
                Button.button [ Button.primary, Button.onClick <| BuyProduct product ] [ text "Buy" ]
            ]


viewProductForm : Model -> Shops.ScalarCodecs.Id -> Html Msg
viewProductForm model shopId =
    let
        (Id shopIdString) =
            shopId
    in
    div [ class "product-form text-center" ]
        [ viewInput
            "text"
            "Product name"
            (Maybe.map .name (Dict.get shopIdString model.productInputs) |> Maybe.withDefault "")
            (ChangeProductName shopIdString)
        , viewInput
            "text"
            "Product slug"
            (Maybe.map .slug (Dict.get shopIdString model.productInputs) |> Maybe.withDefault "")
            (ChangeProductSlug shopIdString)
        , viewInput
            "text"
            "Product stock"
            (String.fromInt (Maybe.map .stock (Dict.get shopIdString model.productInputs) |> Maybe.withDefault 0))
            (String.toInt >> Maybe.withDefault 0 >> ChangeProductStock shopIdString)
        , viewInput
            "text"
            "Product price"
            (String.fromInt (Maybe.map .price (Dict.get shopIdString model.productInputs) |> Maybe.withDefault 0))
            (String.toInt >> Maybe.withDefault 0 >> ChangeProductPrice shopIdString)
        , button [ onClick <| PostProduct shopId ] [ text "Add product" ]
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
