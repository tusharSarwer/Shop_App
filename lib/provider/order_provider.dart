// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/cart_provider.dart';

class OrderItem {
  final String id;
  final List<Cart> cartProduct;
  final double totalAmount;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.cartProduct,
    required this.totalAmount,
    required this.dateTime,
  });
}

class OrderProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  OrderProvider(this.authToken, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchingAndSetOrders() async {
    // var url = Uri.https(
    //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
    //   '/orders.json',
    // );

    String address =
        'https://shop-app-b4b1d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    var url = Uri.parse(address);

    final response = await http.get(url);
    // print(response.body);
    final List<OrderItem> loadedOrderItem = [];
    final extractedOrderItem =
        json.decode(response.body) as Map<String, dynamic>;

    if (extractedOrderItem == null) {
      return;
    }

    extractedOrderItem.forEach(
      (orderId, orderItem) => loadedOrderItem.add(
        OrderItem(
          id: orderId,
          totalAmount: orderItem['amount'],
          dateTime: DateTime.parse(orderItem['dateTime']),
          cartProduct: (orderItem['cartProduct'] as List<dynamic>)
              .map(
                (item) => Cart(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
        ),
      ),
    );
    _orders = loadedOrderItem.reversed.toList();
    notifyListeners();
  }

  Future<void> addItem(List<Cart> cartProduct, double total) async {
    // var url = Uri.https(
    //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
    //   '/orders.json',
    // );

    String address =
        'https://shop-app-b4b1d-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    var url = Uri.parse(address);

    final timeStamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'cartProduct': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        cartProduct: cartProduct,
        totalAmount: total,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
