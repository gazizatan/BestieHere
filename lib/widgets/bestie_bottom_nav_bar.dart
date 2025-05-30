import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/map_screen.dart';
import '../main.dart';

class BestieBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BestieBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;
    return Container(
      decoration: BoxDecoration(
        gradient: theme.navBarGradient,
      ),
      child: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              if (index == currentIndex) return;
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/');
                  break;
                case 1:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, '/messages');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/profile');
                  break;
              }
            },
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Icon(
                  themeProvider.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                ),
                tooltip: themeProvider.isDark ? 'Light Theme' : 'Dark Theme',
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 