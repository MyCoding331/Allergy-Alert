import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<ProductResultV3?> getProduct(String barcode) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('results');

    if (productsJson != null) {
      final products = productsJson
          .map((productJson) =>
              ProductResultV3.fromJson(jsonDecode(productJson)))
          .toList();

      final cachedProduct = products.firstWhere(
        (product) => product.product?.barcode == barcode,
      );

      return cachedProduct;
    }

    return null;
  }

  static Future<void> saveProduct(
      ProductResultV3 product, String productJson) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('results') ?? [];

    final productJson = jsonEncode(product.toJson());
    productsJson.add(productJson);

    await prefs.setStringList('products', productsJson);
  }
}
