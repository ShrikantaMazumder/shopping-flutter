import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/screens/edit_product_screen.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';
import 'package:shopping_flutter/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return UserProductItem(
            title: products[index].title,
            imageUrl: products[index].imageUrl,
          );
        },
      ),
    );
  }
}
