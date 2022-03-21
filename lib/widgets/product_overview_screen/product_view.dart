// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';

import './product_item.dart';

class ProductView extends StatelessWidget {
  final bool showFavorite;

  ProductView({required this.showFavorite});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context, listen: false);
    final products =
        showFavorite ? productData.favoriteItems : productData.item;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(
            // id: productData[index].id,
            // title: productData[index].title,
            // imageUrl: productData[index].imageUrl,
            ),
      ),
      itemCount: products.length,
    );
  }
}
