import 'package:flutter/material.dart';

class UserDataModel extends ChangeNotifier {
  String _userId = "";
  bool _loginStatus = false;

  String get userId => _userId;
  bool get loginStatus => _loginStatus;

  void updateUserId(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }

  void updateLoginStatus(bool updateStatusLogin) {
    _loginStatus = updateStatusLogin;
    notifyListeners();
  }

  int _cartCount = 0;

  int get cartCount => _cartCount;

  void updateCartCount(int newCount) {
    _cartCount = newCount;
    notifyListeners();
  }
}
