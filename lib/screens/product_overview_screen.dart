// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/product_overview_screen/product_view.dart';

import './cart_screen.dart';
import '../provider/product_provider.dart';
import '../widgets/product_overview_screen/badge.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  // var _isInit = true;
  // var _isloading = false;

  Future? _productOverview;

  Future _fetchProduct() {
    return Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  void initState() {
    _productOverview = _fetchProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.Favorite) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
                setState(() {});
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorite,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
              ],
            ),
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                child: ch!,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _productOverview,
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text(
                    'Something went wrong!',
                    style: TextStyle(fontSize: 25),
                  ),
                );
              } else {
                return ProductView(
                  showFavorite: _showOnlyFavorites,
                );
              }
            }
          },
        ),
      ),
    );
  }
}
