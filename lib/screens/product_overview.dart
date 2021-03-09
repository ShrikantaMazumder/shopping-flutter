import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    int selectedMenu = 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping"),
        actions: [
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
          )
        ],
      ),
      body: ProductGrid(_showFavsOnly),
    );
  }
}