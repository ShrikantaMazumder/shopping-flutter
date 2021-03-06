import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/models/product.dart';
import 'package:shopping_flutter/providers/auth_provider.dart';
import 'package:shopping_flutter/providers/cart.dart';
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
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    final scaffold = Scaffold.of(context);
    final primaryColor = Theme.of(context).primaryColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
                placeholder:
                    AssetImage("assets/images/product-placeholder.png"),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (context, product, _) {
              return IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () async {
                  try {
                    await product.toggleFavStatus(
                        authData.token, authData.getUserId);
                  } catch (error) {
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          "Failed to add as favorite",
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: primaryColor,
                      ),
                    );
                  }
                },
              );
            },
          ),
          trailing: IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addToCart(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added to Cart"),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
