import 'package:flutter/material.dart';
import 'package:shopping_flutter/screens/cart_screen.dart';
import 'package:shopping_flutter/screens/edit_product_screen.dart';
import 'package:shopping_flutter/screens/order_screen.dart';
import 'package:shopping_flutter/screens/product_detail_screen.dart';
import 'package:shopping_flutter/screens/user_products_screen.dart';

class Routes {
  // static const homeScreen = "/";
  static const productDetail = ProductDetailScreen.routeName;
  static const cartScreen = CartScreen.routeName;
  static const orderScreen = OrderScreen.routeName;
  static const userProductScreen = UserProductsScreen.routeName;
  static const editProductScreen = EditProductScreen.routeName;

  final routes = <String, WidgetBuilder>{
    // Routes.homeScreen: (context) => ProductOverviewScreen(),
    Routes.productDetail: (context) => ProductDetailScreen(),
    Routes.cartScreen: (context) => CartScreen(),
    Routes.orderScreen: (context) => OrderScreen(),
    Routes.userProductScreen: (context) => UserProductsScreen(),
    Routes.editProductScreen: (context) => EditProductScreen(),
  };
}
