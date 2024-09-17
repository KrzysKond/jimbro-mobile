import 'package:flutter/material.dart';
import 'package:jimbro_mobile/splash.dart';
import 'login_screen.dart';
import 'main.dart';
import 'signup_screen.dart';
import 'add_workout.dart';
import 'home_screen.dart';
import 'auth_service.dart';
import 'splash.dart'; // Import splash screen

class Routes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String addWorkout = '/addWorkout';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => SplashScreen(),
      home: (context) => MyHomePage(),
      login: (context) => LoginScreen(),
      signup: (context) => SignupScreen(),
      addWorkout: (context) => const AddWorkoutForm(),
    };
  }
}
