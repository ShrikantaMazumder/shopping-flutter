import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/cart.dart';
import 'package:shopping_flutter/widgets/cart_screen_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final totalAmount = Provider.of<Cart>(context).totalAmount;
    final cartItems = Provider.of<Cart>(context).cartItems;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$$totalAmount",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    elevation: 1,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      "ORDER NOW",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartScreenItem(
                  title: cartItems.values.toList()[index].title,
                  price: cartItems.values.toList()[index].price,
                  quantity: cartItems.values.toList()[index].quantity,
                );
              },
              itemCount: cartItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
