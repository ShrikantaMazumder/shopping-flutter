import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavStatus() async {
    final oldFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/products/$id";
    try {
      final response = await http.patch(url,
          body: jsonEncode(
            {
              "isFavorite": !isFavorite,
            },
          ));

      if (response.statusCode >= 404) {
        _setFavValue(oldFav);
      }
    } catch (error) {
      _setFavValue(oldFav);
    }
  }
}
