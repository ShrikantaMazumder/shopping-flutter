import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/auth_provider.dart';
import 'package:shopping_flutter/providers/cart.dart';
import 'package:shopping_flutter/providers/order_provider.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/routes/routes.dart';
import 'package:shopping_flutter/screens/auth_screen.dart';
import 'package:shopping_flutter/screens/product_overview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: null,
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token,
            auth.getUserId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
            create: null,
            update: (ctx, auth, prevOrders) => OrderProvider(auth.token,
                auth.getUserId, prevOrders == null ? [] : prevOrders.orders)),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: "Lato",
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              // : FutureBuilder(
              //     future: auth.tryAutoLogIn(),
              //     builder: (ctx, snapshot) =>
              //         snapshot.connectionState == ConnectionState.waiting
              //             ? SplashScreen()
              : AuthScreen(),
          // ),
          routes: Routes().routes,
        ),
      ),
    );
  }
}
