import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [AppTheme.darkBackgroundColor, AppTheme.darkSurfaceColor]
                : [AppTheme.backgroundColor, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isDarkMode ? Icons.dark_mode : Icons.light_mode,
                              color: isDarkMode
                                  ? AppTheme.darkSecondaryColor
                                  : AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dark Mode',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            themeProvider.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                          activeColor: AppTheme.darkSecondaryColor,
                          activeTrackColor: AppTheme.darkPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Emergency Alerts'),
                      subtitle: const Text('Get notified about emergency situations'),
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement notification toggle
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkSecondaryColor
                          : AppTheme.primaryColor,
                    ),
                    SwitchListTile(
                      title: const Text('Location Updates'),
                      subtitle: const Text('Share your location with trusted contacts'),
                      value: true,
                      onChanged: (value) {
                        // TODO: Implement location sharing toggle
                      },
                      activeColor: isDarkMode
                          ? AppTheme.darkSecondaryColor
                          : AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: isDarkMode
                            ? AppTheme.darkSecondaryColor
                            : AppTheme.primaryColor,
                      ),
                      title: const Text('Version'),
                      subtitle: const Text('1.0.0'),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.privacy_tip_outlined,
                        color: isDarkMode
                            ? AppTheme.darkSecondaryColor
                            : AppTheme.primaryColor,
                      ),
                      title: const Text('Privacy Policy'),
                      onTap: () {
                        // TODO: Navigate to privacy policy
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.description_outlined,
                        color: isDarkMode
                            ? AppTheme.darkSecondaryColor
                            : AppTheme.primaryColor,
                      ),
                      title: const Text('Terms of Service'),
                      onTap: () {
                        // TODO: Navigate to terms of service
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Settings tab index
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isDarkMode
            ? AppTheme.darkSecondaryColor
            : AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
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
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/map');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/messages');
              break;
            case 3:
              // Already on settings screen
              break;
          }
        },
      ),
    );
  }
}
