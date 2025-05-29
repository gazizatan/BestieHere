import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Appearance',
            [
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Toggle dark/light theme'),
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.setThemeMode(value),
                  );
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'Notifications',
            [
              SwitchListTile(
                title: const Text('Emergency Alerts'),
                subtitle: const Text('Get notified about emergency situations'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement notification settings
                },
              ),
              SwitchListTile(
                title: const Text('Location Updates'),
                subtitle:
                    const Text('Get notified when friends share location'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement location notification settings
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'Privacy',
            [
              ListTile(
                title: const Text('Location Sharing'),
                subtitle: const Text('Manage who can see your location'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement location sharing settings
                },
              ),
              ListTile(
                title: const Text('Emergency Contacts'),
                subtitle: const Text('Manage your emergency contacts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement emergency contacts settings
                },
              ),
            ],
          ),
          _buildSection(
            context,
            'About',
            [
              ListTile(
                title: const Text('Version'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Terms of Service'),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
