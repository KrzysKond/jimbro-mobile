import 'package:flutter/material.dart';

class AuthService {
  // Simulate an authentication status
  bool isAuthenticated = false;

  // A method to log in the user
  void login() {
    isAuthenticated = true;
  }

  // A method to log out the user
  void logout() {
    isAuthenticated = false;
  }
}

// Create an instance of AuthService
final AuthService authService = AuthService();