import 'package:shopping_flutter/models/cart.dart';

class Order {
  final String id;
  final double total;
  final List<Cart> products;
  final DateTime dateTime;

  Order({
    this.id,
    this.total,
    this.products,
    this.dateTime,
  });
}
