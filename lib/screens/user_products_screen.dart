import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/screens/edit_product_screen.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';
import 'package:shopping_flutter/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  /// Pull to refresh
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<ProductsProvider>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<ProductsProvider>(
                      builder: (context, products, child) => ListView.builder(
                        itemCount: products.items.length,
                        itemBuilder: (context, index) {
                          return UserProductItem(
                            id: products.items[index].id,
                            title: products.items[index].title,
                            imageUrl: products.items[index].imageUrl,
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
