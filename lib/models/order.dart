import 'package:shopping_flutter/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime dateTime;

  Order({
    this.id,
    this.total,
    this.products,
    this.dateTime,
  });
}
