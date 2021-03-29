import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_flutter/models/http_exceptions.dart';
import 'package:shopping_flutter/models/product.dart';

class ProductsProvider with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> _items = [];

  ProductsProvider(this.token, this.userId, this._items);

  /// Only favorite products
  List<Product> get onlyFavoriteProducts {
    return items.where((product) => product.isFavorite).toList();
  }

  /// All products
  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  /// Fetch from db
  /// Set into local model

  Future fetchAndSetData([bool filterById = false]) async {
    final filterString =
        filterById ? "orderBy='creatorId'&equalTo='$userId'" : "";
    var url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/products.json?auth=$token";
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      url =
          "https://shopping-flutter-57578-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$token";
      final favoriteResponse = await http.get(url);
      final favData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedData = [];

      extractedData.forEach((productId, productValue) {
        loadedData.add(
          Product(
            id: productId,
            title: productValue["title"],
            description: productValue["description"],
            price: productValue["price"],
            imageUrl: productValue["imageUrl"],
            isFavorite: favData == null ? false : favData[productId] ?? false,
          ),
        );
        _items = loadedData;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  /// Add new product to firebase db
  Future addProduct(Product product) async {
    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/products.json?auth=$token";

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "creatorId": userId,
          }));

      print("Product added successfully");
      final decodedResponse = jsonDecode(response.body);
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: decodedResponse["name"],
          creatorId: decodedResponse["creatorId"]);
      _items.add(newProduct);
      // _items.insert(0, new_product); // Product will add at the beginning
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /// product update
  Future updateProduct(String id, updatedProduct) async {
    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/products/$id.json?auth=$token";

    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      try {
        await http.patch(url,
            body: jsonEncode({
              "title": updatedProduct.title,
              "description": updatedProduct.description,
              "price": updatedProduct.price,
            }));
        _items[productIndex] = updatedProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/products/$id.json?auth=$token";
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Failed to delete product");
    }
    existingProduct = null;
  }
}
