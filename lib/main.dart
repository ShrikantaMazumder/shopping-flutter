import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/products_provider.dart';
import 'package:shopping_flutter/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductsProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Lato",
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: ProductOverviewScreen(),
        routes: Routes().routes,
      ),
    );
  }
}
