import graphene
from graphene import Node
from graphene_django.filter import DjangoFilterConnectionField
from graphene_django.types import DjangoObjectType
from .models import Wallet, Customer, Category, Shop, Product


class ShopType(DjangoObjectType):
    class Meta:
        model = Shop


class ProductType(DjangoObjectType):
    class Meta:
        model = Product


class Query(graphene.ObjectType):
    shops = graphene.List(ShopType)
    products = graphene.List(ProductType)

    def resolve_shops(self, info):
        return Shop.objects.all()

    def resolve_products(self, info):
        return Product.objects.all()


schema = graphene.Schema(query=Query)
