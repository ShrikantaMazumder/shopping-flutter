import 'package:flutter/material.dart';

class CartScreenItem extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;

  const CartScreenItem({Key key, this.title, this.price, this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title),
            Text("Qty: $quantity"),
            Text("Price: ${price * quantity}"),
          ],
        ),
      ),
    );
  }
}
