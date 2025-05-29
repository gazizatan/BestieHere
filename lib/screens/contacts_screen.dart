import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('Mom'),
              subtitle: const Text('+7 777 123 4567'),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // TODO: Implement call functionality
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('Best Friend'),
              subtitle: const Text('+7 777 765 4321'),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // TODO: Implement call functionality
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add contact functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 