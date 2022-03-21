// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          // Divider(),
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(Icons.shop_two),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                ProductOverviewScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                OrderScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                UserProductsScreen.routeName,
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app_sharp),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
