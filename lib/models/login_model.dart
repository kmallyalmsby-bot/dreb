import 'package:flutter/material.dart';

class LoginModel {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
  }
}