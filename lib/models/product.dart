import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavorite = false;
  String creatorId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite,
    @required this.creatorId,
  });

  _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavStatus(String token, String userId) async {
    final oldFav = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    try {
      final response = await http.put(url,
          body: jsonEncode(
            isFavorite,
          ));

      if (response.statusCode >= 404) {
        _setFavValue(oldFav);
      }
    } catch (error) {
      _setFavValue(oldFav);
    }
  }
}
