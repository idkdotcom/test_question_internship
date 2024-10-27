import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "";
  String _selectedUsername = "";

  String get userName => _userName;
  String get selectedUsername => _selectedUsername;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setSelectedUsername(String username) {
    _selectedUsername = username;
    notifyListeners();
  }
}