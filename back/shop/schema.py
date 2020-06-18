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


class ShopMutation(graphene.Mutation):
    class Arguments:
        name = graphene.String(required=True)
        slug = graphene.String(required=True)

    shop = graphene.Field(ShopType)

    def mutate(self, info, name, slug):
        wallet = Wallet(value=0)
        wallet.save()

        shop = Shop(name=name, slug=slug, wallet=wallet)
        shop.save()

        # TODO: set the current user as a holder
        holder = Customer.objects.all().first()
        shop.holders.add(holder)

        return ShopMutation(shop=shop)


class ProductMutation(graphene.Mutation):
    class Arguments:
        # id = graphene.ID()
        name = graphene.String(required=True)
        slug = graphene.String(required=True)
        stock = graphene.Int(required=True)
        price = graphene.Int(required=True)
        shopId = graphene.ID(required=True)

    product = graphene.Field(ProductType)

    def mutate(self, info, name, slug, stock, price, shopId):
        shop = Shop.objects.get(pk=shopId)
        # TODO: Get category as well
        category = Category.objects.all().first()
        product = Product(name=name,
                          slug=slug,
                          stock=stock,
                          price=price,
                          shop=shop,
                          category=category)
        product.save()
        return ProductMutation(product=product)


class Mutation(graphene.ObjectType):
    post_product = ProductMutation.Field()
    post_shop = ShopMutation.Field()


schema = graphene.Schema(query=Query, mutation=Mutation)
