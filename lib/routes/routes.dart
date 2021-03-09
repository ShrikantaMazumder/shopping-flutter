import 'package:flutter/material.dart';
import 'package:shopping_flutter/screens/cart_screen.dart';
import 'package:shopping_flutter/screens/product_detail_screen.dart';
import 'package:shopping_flutter/screens/product_overview.dart';

class Routes {
  static const homeScreen = "/";
  static const productDetail = ProductDetailScreen.routeName;
  static const cartScreen = CartScreen.routeName;

  final routes = <String, WidgetBuilder>{
    Routes.homeScreen: (context) => ProductOverviewScreen(),
    Routes.productDetail: (context) => ProductDetailScreen(),
    Routes.cartScreen: (context) => CartScreen(),
  };
}
