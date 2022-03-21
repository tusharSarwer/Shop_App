// ignore_for_file:  prefer_final_fields

import 'package:flutter/foundation.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;
  // bool isInCart;

  Cart({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    // this.isInCart = false,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, Cart> _item = {};

  Map<String, Cart> get item {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get totalCount {
    var total = 0.0;
    _item.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_item.containsKey(productId)) {
      _item.update(
        productId,
        (value) => Cart(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _item.putIfAbsent(
        productId,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_item.containsKey(productId)) {
      return;
    }
    if (_item[productId]!.quantity > 1) {
      _item.update(
        productId,
        (value) => Cart(
          id: value.id,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
        ),
      );
    } else {
      _item.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _item = {};
    notifyListeners();
  }
}
