// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_screen/orders_view.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // var _isLoading = false;

  Future? _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<OrderProvider>(context, listen: false)
        .fetchingAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<OrderProvider>(context);
    // final order = orderData.orders;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Order'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text(
                    'No Order!!',
                    style: TextStyle(fontSize: 25),
                  ),
                  // 'An error occurred'
                );
              } else {
                return Consumer<OrderProvider>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) => OrderView(
                      order: orderData.orders[index],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
