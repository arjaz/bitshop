-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Shops.Object.WalletType exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Shops.InputObject
import Shops.Interface
import Shops.Object
import Shops.Scalar
import Shops.ScalarCodecs
import Shops.Union


{-| -}
id : SelectionSet Shops.ScalarCodecs.Id Shops.Object.WalletType
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Shops.ScalarCodecs.codecs |> Shops.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| -}
value : SelectionSet Int Shops.Object.WalletType
value =
    Object.selectionForField "Int" "value" [] Decode.int


customer :
    SelectionSet decodesTo Shops.Object.CustomerType
    -> SelectionSet (Maybe decodesTo) Shops.Object.WalletType
customer object_ =
    Object.selectionForCompositeField "customer" [] object_ (identity >> Decode.nullable)


shop :
    SelectionSet decodesTo Shops.Object.ShopType
    -> SelectionSet (Maybe decodesTo) Shops.Object.WalletType
shop object_ =
    Object.selectionForCompositeField "shop" [] object_ (identity >> Decode.nullable)
