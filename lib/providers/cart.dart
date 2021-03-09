import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get cartItems {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void addToCart(String productId, String title, double price) {
    final product = _items.containsKey(productId);
    if (product) {
      _items.update(
        productId,
        (existingCart) => CartItem(
          id: existingCart.id,
          title: existingCart.title,
          price: existingCart.price,
          quantity: existingCart.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }
}
