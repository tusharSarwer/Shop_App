// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedData =
        Provider.of<ProductProvider>(context).findById(productId);

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(loadedData.title!),
        // ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  loadedData.title!,
                  style: TextStyle(color: Colors.pink),
                ),
                background: Hero(
                  tag: loadedData.id.toString(),
                  child: Image.network(
                    loadedData.imageUrl.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$ ${loadedData.price}',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      loadedData.description!,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
