from django.contrib import admin

from .models import Wallet, Customer, Category, Product, Shop

admin.site.register(Wallet)
admin.site.register(Customer)
admin.site.register(Category)
admin.site.register(Product)
admin.site.register(Shop)
