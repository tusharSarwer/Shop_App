// ignore_for_file: unused_field, prefer_final_fields, avoid_print, use_rethrow_when_possible, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class ProductProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this.userId, this._item);

  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get item {
    return [..._item];
  }

  List<Product> get favoriteItems {
    return _item.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // var url = Uri.https(
    //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
    //   '/products.json?auth=$authToken',
    // );

    final filterQuery =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    String address =
        'https://shop-app-b4b1d-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterQuery';
    var url = Uri.parse(address);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      String address =
          'https://shop-app-b4b1d-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken';
      var urlFav = Uri.parse(address);

      final favoriteResponse = await http.get(urlFav);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ),);
      });

      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // This is One way to addProduct and Handle the error if occurred

  // Future<void> addProduct(Product product) async {
  //   var url = Uri.https(
  //     'shop-app-b4b1d-default-rtdb.firebaseio.com',
  //     '/products',
  //   );
  //   await http
  //       .post(
  //     url,
  //     body: json.encode({
  //       'title': product.title,
  //       'description': product.description,
  //       'imageUel': product.imageUrl,
  //       'price': product.price,
  //       'isFavorite': product.isFavorite,
  //     }),
  //   )
  //       .then((response) {
  //     print(json.decode(response.body));
  //     final newProduct = Product(
  //       id: json.decode(response.body)['name'],
  //       title: product.title,
  //       description: product.description,
  //       imageUrl: product.imageUrl,
  //       price: product.price,
  //     );
  //     _item.add(newProduct);
  //     notifyListeners();
  //   }).catchError((error) {
  //     print(error);
  //     throw error;
  //   });
  // }

  // This is the 2nd way to addProduct and Handle the error if occurred

  Future<void> addProduct(Product product) async {
    // var url = Uri.https(
    //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
    //   '/products.json',
    // );

    String address =
        'https://shop-app-b4b1d-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    var url = Uri.parse(address);

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _item.add(newProduct);
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _item.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      // var url = Uri.https(
      //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
      //   '/products/$id.json',
      // );

      String address =
          'https://shop-app-b4b1d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      var url = Uri.parse(address);

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _item[productIndex] = newProduct;
    } else {
      print('...');
    }
    // _item[productIndex] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    // var url = Uri.https(
    //   'shop-app-b4b1d-default-rtdb.firebaseio.com',
    //   '/products/$id.json',
    // );

    String address =
        'https://shop-app-b4b1d-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    var url = Uri.parse(address);

    final existingProductIndex =
        _item.indexWhere((element) => element.id == id);

    Product? existingProduct = _item[existingProductIndex];

    _item.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product');
    }
    existingProduct = null;
  }
}
