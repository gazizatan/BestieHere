import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String help = '/help';
  static const String safety = '/safety';
  static const String emergencyContacts = '/emergency-contacts';
  static const String safePlaces = '/safe-places';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/settings':
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Settings'))));
      case '/help':
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Help & Support'))));
      case '/safety':
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Safety Features'))));
      case '/emergency-contacts':
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text('Emergency Contacts'))));
      case '/safe-places':
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Safe Places'))));
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
