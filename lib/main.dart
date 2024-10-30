import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
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
