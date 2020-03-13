#!/usr/bin/env python
# -*- coding: utf-8 -*-
# __coconut_hash__ = 0xede61f5a

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
from rest_framework import serializers  # line 2: from rest_framework import serializers

from .models import Wallet  # line 4: from .models import Wallet, Customer, Category, Shop, Product
from .models import Customer  # line 4: from .models import Wallet, Customer, Category, Shop, Product
from .models import Category  # line 4: from .models import Wallet, Customer, Category, Shop, Product
from .models import Shop  # line 4: from .models import Wallet, Customer, Category, Shop, Product
from .models import Product  # line 4: from .models import Wallet, Customer, Category, Shop, Product


class UserSerializer(serializers.HyperlinkedModelSerializer):  # line 7: class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 8:     class Meta:
        model = User  # line 9:         model = User
        fields = ['url', 'username', 'email', 'groups']  # line 10:         fields = ['url', 'username', 'email', 'groups']


class GroupSerializer(serializers.HyperlinkedModelSerializer):  # line 13: class GroupSerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 14:     class Meta:
        model = Group  # line 15:         model = Group
        fields = ['url', 'name']  # line 16:         fields = ['url', 'name']


class WalletSerializer(serializers.HyperlinkedModelSerializer):  # line 19: class WalletSerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 20:     class Meta:
        model = Wallet  # line 21:         model = Wallet
        fields = ['value']  # line 22:         fields = ['value']


class CustomerSerializer(serializers.HyperlinkedModelSerializer):  # line 25: class CustomerSerializer(serializers.HyperlinkedModelSerializer):
    user = serializers.ReadOnlyField(source='user.username')  # line 26:     user = serializers.ReadOnlyField(source='user.username')

    class Meta(_coconut.object):  # line 28:     class Meta:
        model = Customer  # line 29:         model = Customer
        fields = ['user', 'wallet']  # line 30:         fields = ['user', 'wallet']


class CategorySerializer(serializers.HyperlinkedModelSerializer):  # line 33: class CategorySerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 34:     class Meta:
        model = Category  # line 35:         model = Category
        fields = ['name', 'slug']  # line 36:         fields = ['name', 'slug']


class ShopSerializer(serializers.HyperlinkedModelSerializer):  # line 39: class ShopSerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 40:     class Meta:
        model = Shop  # line 41:         model = Shop
        fields = ['name', 'slug', 'image', 'wallet', 'onwers']  # line 42:         fields = ['name', 'slug', 'image', 'wallet', 'onwers']


class ProductSerializer(serializers.HyperlinkedModelSerializer):  # line 45: class ProductSerializer(serializers.HyperlinkedModelSerializer):
    class Meta(_coconut.object):  # line 46:     class Meta:
        model = Product  # line 47:         model = Product
        fields = ['name', 'slug', 'stock', 'image', 'price', 'category', 'shop']  # line 48:         fields = [
