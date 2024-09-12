import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'main.dart';
import 'signup_screen.dart';
import 'add_workout.dart';
import 'home_screen.dart';
import 'auth_service.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String addWorkout = '/addWorkout';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) {
        // Check if the user is authenticated
        if (!authService.isAuthenticated) {
          // Redirect to login screen if not authenticated
          return LoginScreen();
        }
        return MyHomePage();
      },

      login: (context) => LoginScreen(),
      signup: (context) => SignupScreen(),
      addWorkout: (context) => const AddWorkoutForm(),
    };
  }
}
