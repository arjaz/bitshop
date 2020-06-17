import graphene
from graphene import Node
from graphene_django.filter import DjangoFilterConnectionField
from graphene_django.types import DjangoObjectType
from .models import Wallet, Customer, Category, Shop, Product


class ShopType(DjangoObjectType):
    class Meta:
        model = Shop


class WalletType(DjangoObjectType):
    class Meta:
        model = Wallet


class CustomerType(DjangoObjectType):
    class Meta:
        model = Customer


class ProductType(DjangoObjectType):
    class Meta:
        model = Product


class CategoryType(DjangoObjectType):
    class Meta:
        model = Category


class Query(graphene.ObjectType):
    all_shops = graphene.NonNull(graphene.List(graphene.NonNull(ShopType)))
    all_products = graphene.NonNull(
        graphene.List(graphene.NonNull(ProductType)))

    def resolve_all_shops(self, info, **kwargs):
        return Shop.objects.all()

    def resolve_all_products(self, info, **kwargs):
        return Product.objects.all()


schema = graphene.Schema(query=Query)
