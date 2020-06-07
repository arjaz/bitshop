from django.contrib import admin
from django.urls import path, include
from rest_framework import routers
from graphene_django.views import GraphQLView
from shop import views
from shop.schema import schema

router = routers.DefaultRouter()
router.register('customers', views.CustomerViewSet)
router.register('groups', views.GroupViewSet)
router.register('shops', views.ShopViewSet)
router.register('products', views.ProductViewSet)
router.register('wallets', views.WalletViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api-auth/', include('rest_framework.urls',
                              namespace='rest_framework')),
    path('api/', include(router.urls)),
    path('graphql/', GraphQLView.as_view(schema=schema, graphiql=True))
]
