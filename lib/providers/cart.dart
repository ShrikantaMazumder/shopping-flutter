import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopping_flutter/models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get cartItems {
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
        (existingCart) => Cart(
          id: existingCart.id,
          title: existingCart.title,
          price: existingCart.price,
          quantity: existingCart.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeCart(String itemKey) {
    _items.remove(itemKey);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
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
