import 'package:flutter/material.dart';
import 'service/auth_service.dart';
import 'routes.dart'; // Import routes to navigate

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn(); // Assuming isLoggedIn is an async method

    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
