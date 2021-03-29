import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_flutter/models/cart.dart';
import 'package:shopping_flutter/models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  final String authData;
  final String userId;

  OrderProvider(this.authData, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<Cart> products, double total) async {
    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/orders.json?auth=$authData";
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
      _orders.insert(
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
    final url =
        "https://shopping-flutter-57578-default-rtdb.firebaseio.com/orders.json?auth=$authData";
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
          return Cart(
            id: item["id"],
            title: item["title"],
            price: item["price"],
            quantity: item["quantity"],
          );
        }).toList(),
      ));
    });

    /// reversed.toList() for ordering data by date modified.
    _orders = loadedOrder.reversed.toList();

    notifyListeners();
  }
}
