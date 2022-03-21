// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/order_provider.dart';

class OrderView extends StatefulWidget {
  final OrderItem order;

  OrderView({required this.order});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${widget.order.totalAmount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              AnimatedContainer(
                duration: Duration(seconds: 3),
                // curve: Curves.decelerate,
                height: min(widget.order.cartProduct.length * 20.0 + 40, 180),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListView(
                  children: [
                    ...widget.order.cartProduct
                        .map(
                          (e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${e.quantity}x \$ ${e.price}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
