import 'package:flutter/material.dart';
import 'package:shopping_flutter/models/order.dart';
import 'package:shopping_flutter/providers/cart.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get orders {
    return [..._items];
  }

  void addOrder(List<CartItem> products, double total) {
    _items.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        total: total,
        products: products,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
