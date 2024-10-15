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
    final isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Routes.login, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
