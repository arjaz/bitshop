#!/usr/bin/env python
# -*- coding: utf-8 -*-
# __coconut_hash__ = 0xf1eb601b

# Compiled with Coconut version 1.4.3 [Ernest Scribbler]

# Coconut Header: -------------------------------------------------------------

from __future__ import print_function, absolute_import, unicode_literals, division
import sys as _coconut_sys, os.path as _coconut_os_path
_coconut_file_path = _coconut_os_path.dirname(_coconut_os_path.abspath(__file__))
_coconut_cached_module = _coconut_sys.modules.get(str("__coconut__"))
if _coconut_cached_module is not None and _coconut_os_path.dirname(_coconut_cached_module.__file__) != _coconut_file_path:
    del _coconut_sys.modules[str("__coconut__")]
_coconut_sys.path.insert(0, _coconut_file_path)
from __coconut__ import *
from __coconut__ import _coconut, _coconut_MatchError, _coconut_tail_call, _coconut_tco, _coconut_igetitem, _coconut_base_compose, _coconut_forward_compose, _coconut_back_compose, _coconut_forward_star_compose, _coconut_back_star_compose, _coconut_forward_dubstar_compose, _coconut_back_dubstar_compose, _coconut_pipe, _coconut_back_pipe, _coconut_star_pipe, _coconut_back_star_pipe, _coconut_dubstar_pipe, _coconut_back_dubstar_pipe, _coconut_bool_and, _coconut_bool_or, _coconut_none_coalesce, _coconut_minus, _coconut_map, _coconut_partial, _coconut_get_function_match_error, _coconut_base_pattern_func, _coconut_addpattern, _coconut_sentinel, _coconut_assert, _coconut_mark_as_match
if _coconut_sys.version_info >= (3,):
    _coconut_sys.path.pop(0)

# Compiled Coconut: -----------------------------------------------------------

from django.contrib.auth.models import User  # line 1: from django.contrib.auth.models import User, Group
from django.contrib.auth.models import Group  # line 1: from django.contrib.auth.models import User, Group
from django.http import JsonResponse  # line 2: from django.http import JsonResponse
from rest_framework import viewsets  # line 3: from rest_framework import viewsets
from rest_framework import permissions  # line 4: from rest_framework import permissions

from .models import Wallet  # line 6: from .models import Wallet, Customer, Category, Shop, Product
from .models import Customer  # line 6: from .models import Wallet, Customer, Category, Shop, Product
from .models import Category  # line 6: from .models import Wallet, Customer, Category, Shop, Product
from .models import Shop  # line 6: from .models import Wallet, Customer, Category, Shop, Product
from .models import Product  # line 6: from .models import Wallet, Customer, Category, Shop, Product
from .serializers import UserSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import GroupSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import CustomerSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import ShopSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import ProductSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import WalletSerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer
from .serializers import CategorySerializer  # line 7: from .serializers import UserSerializer, GroupSerializer, CustomerSerializer, ShopSerializer, ProductSerializer, WalletSerializer, CategorySerializer


class UserViewSet(viewsets.ModelViewSet):  # line 10: class UserViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows users to be viewed or edited.
    """  # line 13:     """
    queryset = User.objects.all().order_by('-date_joined')  # line 14:     queryset = User.objects.all().order_by('-date_joined')
    serializer_class = UserSerializer  # line 15:     serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 16:     permission_classes = [permissions.IsAuthenticated]


class GroupViewSet(viewsets.ModelViewSet):  # line 19: class GroupViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows groups to be viewed or edited.
    """  # line 22:     """
    queryset = Group.objects.all()  # line 23:     queryset = Group.objects.all()
    serializer_class = GroupSerializer  # line 24:     serializer_class = GroupSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 25:     permission_classes = [permissions.IsAuthenticated]


class CustomerViewSet(viewsets.ModelViewSet):  # line 28: class CustomerViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows customers to be viewed or edited.
    """  # line 31:     """
    queryset = Customer.objects.all()  # line 32:     queryset = Customer.objects.all()
    serializer_class = CustomerSerializer  # line 33:     serializer_class = CustomerSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 34:     permission_classes = [permissions.IsAuthenticated]


class CategoryViewSet(viewsets.ModelViewSet):  # line 37: class CategoryViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows categories to be viewed or edited.
    """  # line 40:     """
    queryset = Category.objects.all()  # line 41:     queryset = Category.objects.all()
    serializer_class = CategorySerializer  # line 42:     serializer_class = CategorySerializer
    permission_classes = [permissions.IsAuthenticated]  # line 43:     permission_classes = [permissions.IsAuthenticated]


class ShopViewSet(viewsets.ModelViewSet):  # line 46: class ShopViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows shops to be viewed or edited.
    """  # line 49:     """
    queryset = Shop.objects.all()  # line 50:     queryset = Shop.objects.all()
    serializer_class = ShopSerializer  # line 51:     serializer_class = ShopSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 52:     permission_classes = [permissions.IsAuthenticated]


class ProductViewSet(viewsets.ModelViewSet):  # line 55: class ProductViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows products to be viewed or edited.
    """  # line 58:     """
    queryset = Product.objects.all()  # line 59:     queryset = Product.objects.all()
    serializer_class = ProductSerializer  # line 60:     serializer_class = ProductSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 61:     permission_classes = [permissions.IsAuthenticated]


class WalletViewSet(viewsets.ModelViewSet):  # line 64: class WalletViewSet(viewsets.ModelViewSet):
    """
    API endpoint that allows wallets to be viewed or edited.
    """  # line 67:     """
    queryset = Wallet.objects.all()  # line 68:     queryset = Wallet.objects.all()
    serializer_class = WalletSerializer  # line 69:     serializer_class = WalletSerializer
    permission_classes = [permissions.IsAuthenticated]  # line 70:     permission_classes = [permissions.IsAuthenticated]


@_coconut_tco  # line 73: def usernames(request) =
def usernames(request):  # line 73: def usernames(request) =
    return _coconut_tail_call((lambda x: (JsonResponse)({'usernames': x})), (list)(map(lambda x: x.username, User.objects.all())))  # line 74:     User.objects.all() |> map$(x -> x.username) |> list |> x -> {'usernames': x} |> JsonResponse
