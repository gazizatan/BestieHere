import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/safety/safety_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String safety = '/safety';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case safety:
        return MaterialPageRoute(builder: (_) => const SafetyScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
