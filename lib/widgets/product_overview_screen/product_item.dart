// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  //
  // const ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                  arguments: product.id);
            },
            child: Hero(
              tag: product.id.toString(),
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl.toString()),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: () {
                product.toggleFavorite(auth.token!, auth.userId!);
              },
            ),
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              cart.addItem(product.id!, product.title!, product.price!);
              // Scaffold.of(context).openDrawer();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id!);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// context.read<Product>().toggleFavorite();
// Theme.of(context).accentColor
