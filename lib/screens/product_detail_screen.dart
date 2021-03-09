import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductsProvider>(
      context,

      /// This will not listen any update / will not rebuild for any where update
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text(product.title),
      ),
    );
  }
}
