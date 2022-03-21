// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/widgets/user_products_screen/user_product_item.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ProductProvider>(context).item;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Product Item'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<ProductProvider>(
                    builder: (context, product, _) => Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: product.item.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            UserProductItem(
                              id: product.item[index].id!,
                              title: product.item[index].title!,
                              imageUrl: product.item[index].imageUrl.toString(),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
