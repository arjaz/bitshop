#!/usr/bin/env python
# -*- coding: utf-8 -*-
# __coconut_hash__ = 0xf1a83147

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

from django.db import models  # line 1: from django.db import models
from django.contrib.auth.models import User  # line 2: from django.contrib.auth.models import User


class Wallet(models.Model):  # line 5: class Wallet(models.Model):
# satoshi
    value = models.PositiveIntegerField()  # line 7:     value = models.PositiveIntegerField()


class Customer(models.Model):  # line 10: class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # line 11:     user = models.OneToOneField(User, on_delete=models.CASCADE)
    wallet = models.OneToOneField(Wallet, on_delete=models.CASCADE, unique=True)  # line 12:     wallet = models.OneToOneField(Wallet, on_delete=models.CASCADE, unique=True)

    def __str__(self):  # line 14:     def __str__(self) = self.user.username
        return self.user.username  # line 14:     def __str__(self) = self.user.username


class Category(models.Model):  # line 17: class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)  # line 18:     name = models.CharField(max_length=50, unique=True)
    slug = models.SlugField(max_length=50, unique=True)  # line 19:     slug = models.SlugField(max_length=50, unique=True)

    class Meta(_coconut.object):  # line 21:     class Meta:
        verbose_name_plural = "categories"  # line 22:         verbose_name_plural = "categories"

    def __str__(self):  # line 24:     def __str__(self) = self.name
        return self.name  # line 24:     def __str__(self) = self.name


class Shop(models.Model):  # line 27: class Shop(models.Model):
    name = models.CharField(max_length=50, unique=True)  # line 28:     name = models.CharField(max_length=50, unique=True)
    slug = models.SlugField(max_length=50, unique=True)  # line 29:     slug = models.SlugField(max_length=50, unique=True)
    image = models.ImageField(blank=True, upload_to="images/shops")  # line 30:     image = models.ImageField(blank=True, upload_to="images/shops")
    wallet = models.OneToOneField(Wallet, on_delete=models.CASCADE, unique=True)  # line 31:     wallet = models.OneToOneField(Wallet, on_delete=models.CASCADE, unique=True)
    owners = models.ManyToManyField(Customer)  # line 32:     owners = models.ManyToManyField(Customer)

    def __str__(self):  # line 34:     def __str__(self) = self.name
        return self.name  # line 34:     def __str__(self) = self.name


class Product(models.Model):  # line 37: class Product(models.Model):
    name = models.CharField(max_length=50)  # line 38:     name = models.CharField(max_length=50)
    slug = models.SlugField(max_length=50, unique=True)  # line 39:     slug = models.SlugField(max_length=50, unique=True)
    stock = models.PositiveIntegerField()  # line 40:     stock = models.PositiveIntegerField()
    image = models.ImageField(blank=True, upload_to="images/products")  # line 41:     image = models.ImageField(blank=True, upload_to="images/products")
# satoshi
    price = models.PositiveIntegerField()  # line 43:     price = models.PositiveIntegerField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE)  # line 44:     category = models.ForeignKey(Category, on_delete=models.CASCADE)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)  # line 45:     shop = models.ForeignKey(Shop, on_delete=models.CASCADE)

    def __str__(self):  # line 47:     def __str__(self) = self.name
        return self.name  # line 47:     def __str__(self) = self.name
