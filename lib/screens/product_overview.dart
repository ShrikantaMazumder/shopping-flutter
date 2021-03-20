import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/cart.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/screens/cart_screen.dart';
import 'package:shopping_flutter/widgets/app_drawer.dart';
import 'package:shopping_flutter/widgets/badge.dart';
import 'package:shopping_flutter/widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavsOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetData().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping"),
        actions: [
          /// Badge is a custom widget
          Consumer<CartProvider>(
            builder: (context, cartItem, child) {
              return Badge(
                child: child,
                value: cartItem.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedMenu) {
              setState(() {
                if (FilterOptions.Favorites == selectedMenu) {
                  _showFavsOnly = true;
                } else {
                  _showFavsOnly = false;
                }
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Favorites"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text("All Products"),
                  value: FilterOptions.All,
                ),
              ];
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavsOnly),
    );
  }
}
