import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/product.dart';
import 'package:shopping_flutter/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // const ProductItem({ this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, child) {
              return IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => product.toggleFavStatus(),
              );
            },
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
