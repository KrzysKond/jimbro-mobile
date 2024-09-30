import 'package:flutter/material.dart';
import 'routes.dart'; // Import routes file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JimBro',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFFF6B81),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFF6B81),
          secondary: const Color(0xFF8B0000), // For accent or secondary widgets
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF6B81),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B81),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: Routes.splash, // Set initial route to splash screen
      routes: Routes.routes,
    );
  }
}
