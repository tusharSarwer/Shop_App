// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(
      {required this.title, required this.imageUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName,
                    arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            // Spacer(),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!!!',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
