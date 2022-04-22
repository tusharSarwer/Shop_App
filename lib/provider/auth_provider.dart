// ignore_for_file: avoid_print, use_rethrow_when_possible, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> authentication(
      String email, String password, String urlFormat) async {
    try {
      String address =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlFormat?key=AIzaSyDVuQv5VU6e0paUXBwa3TtEKJsKvfS3C_A';
      var url = Uri.parse(address);

      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      // print(response.body);
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autoLogout();

      notifyListeners();

      final prefer = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      prefer.setString('userData', userData);
    } catch (error) {
      throw error;
    }

    // String address =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:$urlFormat?key=AIzaSyDVuQv5VU6e0paUXBwa3TtEKJsKvfS3C_A';
    // var url = Uri.parse(address);
    //
    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     'email': email,
    //     'password': password,
    //     'returnSecureToken': true,
    //   }),
    // );
    // print(response.body);
  }

  Future<void> signUp(String email, String password) async {
    return authentication(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogIn() async {
    final prefer = await SharedPreferences.getInstance();
    if (!prefer.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData =
          json.decode(prefer.getString('userData').toString())
              as Map<String, dynamic>;
      final expiryData =
          DateTime.parse(extractedUserData['expiryDate'].toString());

      if (expiryData.isBefore(DateTime.now())) {
        return false;
      }

      _token = extractedUserData['token'].toString();
      _userId = extractedUserData['userId'].toString();
      _expiryDate = expiryData;
      notifyListeners();
      _autoLogout();

      print('save user data!');

      return true;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefers = await SharedPreferences.getInstance();
    // prefers.remove('userData');
    prefers.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
