import os
import sys
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'araMarket.settings')

import django
django.setup()

from apps.products.models import ProductImage

images = ProductImage.objects.all()[:5]
for img in images:
    print(f"ID: {img.id}, Product: {img.product.name}, Image URL: {img.image.url}")
