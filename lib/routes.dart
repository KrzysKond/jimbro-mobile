import 'package:flutter/material.dart';
import 'package:jimbro_mobile/screens/create_group.dart';
import 'package:jimbro_mobile/screens/group_screen.dart';
import 'package:jimbro_mobile/screens/search_group_screen.dart';
import 'package:jimbro_mobile/splash.dart';
import 'auth_screens/login_screen.dart';
import 'main.dart';
import 'auth_screens/signup_screen.dart';
import 'screens/add_workout.dart';
import 'screens/home_screen.dart';
import 'service/auth_service.dart';
import 'splash.dart';
import 'screens/group_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String addWorkout = '/addWorkout';
  static const String group = '/group';
  static const String createGroup = '/createGroup';
  static const String searchGroups = '/searchGroups';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => SplashScreen(),
      home: (context) => MyHomePage(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      addWorkout: (context) => const AddWorkoutForm(),
      group: (context) => const GroupScreen(),
      createGroup: (context) => const CreateGroupForm(),
      searchGroups: (context) => JoinGroupScreen(),
    };
  }
}
