// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../widgets/cart_screen/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$ ${cart.totalCount.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    OrderButton(cart: cart),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (context, index) => CartItem(
                  id: cart.item.values.toList()[index].id,
                  productId: cart.item.keys.toList()[index],
                  title: cart.item.values.toList()[index].title,
                  price: cart.item.values.toList()[index].price,
                  quantity: cart.item.values.toList()[index].quantity,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalCount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrderProvider>(context, listen: false).addItem(
                widget.cart.item.values.toList(),
                widget.cart.totalCount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style: TextStyle(
                color: widget.cart.totalCount <= 0
                    ? Colors.grey
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
    );
  }
}
