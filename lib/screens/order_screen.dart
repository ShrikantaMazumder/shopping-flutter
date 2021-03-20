import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/order_provider.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';
import 'package:shopping_flutter/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "order-screen";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  /// These are to protect multiple network call in FutureBuilder
  Future _orderFuture;
  Future _obtainOrderFuture() {
    return Provider.of<OrderProvider>(context, listen: false)
        .fetchAndSetOrder();
  }

  @override
  void initState() {
    _orderFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orderFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("An error occured"),
              );
            } else {
              return Consumer<OrderProvider>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemBuilder: (context, index) {
                    return OrderItem(
                      order: orderData.orders[index],
                    );
                  },
                  itemCount: orderData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
