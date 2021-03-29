import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_flutter/providers/auth_provider.dart';
import 'package:shopping_flutter/screens/order_screen.dart';
import 'package:shopping_flutter/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Welcome to Shopping"),
            automaticallyImplyLeading: false,

            /// This will not add back button automatically
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Order"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          ),
          Divider(),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          if (authProvider.isAuth) ...[
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/");
                authProvider.logout();
              },
            ),
            Divider(),
          ]
        ],
      ),
    );
  }
}
