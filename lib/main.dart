import 'package:flutter/material.dart';
import 'routes.dart'; // Import the routes file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JimBro',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: Routes.home,
      routes: Routes.routes,
    );
  }
}
