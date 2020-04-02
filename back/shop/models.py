from django.db import models
from django.contrib.auth.models import User


class Wallet(models.Model):
    # satoshi
    value = models.PositiveIntegerField()


class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    wallet = models.OneToOneField(Wallet,
                                  on_delete=models.CASCADE,
                                  unique=True)

    def __str__(self):
        # return self.user.name
        return self.user.username


class Category(models.Model):
    name = models.CharField(max_length=50, unique=True)
    slug = models.SlugField(max_length=50, unique=True)

    class Meta:
        verbose_name_plural = "categories"

    def __str__(self):
        return self.name


class Shop(models.Model):
    name = models.CharField(max_length=50, unique=True)
    slug = models.SlugField(max_length=50, unique=True)
    image = models.ImageField(blank=True, upload_to="images/shops")
    wallet = models.OneToOneField(Wallet,
                                  on_delete=models.CASCADE,
                                  unique=True)
    holders = models.ManyToManyField(Customer)

    def __str__(self):
        return self.name


class Product(models.Model):
    name = models.CharField(max_length=50)
    slug = models.SlugField(max_length=50, unique=True)
    stock = models.PositiveIntegerField()
    image = models.ImageField(blank=True, upload_to="images/products")
    # satoshi
    price = models.PositiveIntegerField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    shop = models.ForeignKey(Shop, on_delete=models.CASCADE)

    def __str__(self):
        return self.name
