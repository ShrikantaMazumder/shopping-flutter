import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/cart.dart';

class CartScreenItem extends StatelessWidget {
  final String id;
  final String itemKey;
  final String title;
  final double price;
  final int quantity;

  const CartScreenItem(
      {Key key, this.id, this.itemKey, this.title, this.price, this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartProvider.removeCart(itemKey);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title),
              Text("Qty: $quantity"),
              Text("Price: ${price * quantity}"),
            ],
          ),
        ),
      ),
    );
  }
}
