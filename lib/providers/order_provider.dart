import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_flutter/models/cart.dart';
import 'package:shopping_flutter/models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get orders {
    return [..._items];
  }

  Future<void> addOrder(List<Cart> products, double total) async {
    const url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/orders.json";
    final dateTime = DateTime.now();

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "total": total,
            "dateTime": dateTime.toIso8601String(),
            "products": products.map((cartProd) {
              return {
                "id": cartProd.id,
                "title": cartProd.title,
                "quantity": cartProd.quantity,
                "price": cartProd.price,
              };
            }).toList()
          }));
      _items.insert(
        0,
        Order(
          id: jsonDecode(response.body)["name"],
          total: total,
          products: products,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw HttpException("Failed to add order");
    }
  }

  /// Fetch order
  Future<void> fetchAndSetOrder() async {
    const url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/orders.json";
    final response = await http.get(url);
    List<Order> loadedOrder = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(Order(
        id: orderId,
        total: orderData["total"],
        dateTime: DateTime.parse(orderData["dateTime"]),
        products: (orderData["products"] as List<dynamic>).map((item) {
          Cart(
            id: item["id"],
            title: item["title"],
            price: item["price"],
            quantity: item["quantity"],
          );
        }).toList(),
      ));
    });

    /// reversed.toList() for ordering data by date modified.
    _items = loadedOrder.reversed.toList();
    notifyListeners();
  }
}
