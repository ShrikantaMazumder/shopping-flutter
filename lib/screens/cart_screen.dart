import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/cart.dart';
import 'package:shopping_flutter/providers/order_provider.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';
import 'package:shopping_flutter/widgets/cart_screen_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalAmount = cart.totalAmount;
    final cartItems = cart.cartItems;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      drawer: AppDrawer(),
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
                  OrderButton(
                    cart: cart,
                    totalAmount: totalAmount,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartScreenItem(
                  id: cartItems.values.toList()[index].id,
                  itemKey: cartItems.keys.toList()[index],
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

class OrderButton extends StatefulWidget {
  final cart;
  final totalAmount;

  const OrderButton({Key key, this.cart, this.totalAmount}) : super(key: key);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      onPressed: (widget.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false).addOrder(
                widget.cart.cartItems.values.toList(),
                widget.totalAmount,
              );
              widget.cart.clearCart();
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
