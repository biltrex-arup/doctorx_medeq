import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _email = "";

  String get email => _email;

  // Set email from Screen 1
  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  // Clear when needed (ex: logout)
  void clear() {
    _email = "";
    notifyListeners();
  }
}
