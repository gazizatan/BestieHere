import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bestie_bottom_nav_bar.dart';

class Contact {
  final String name;
  final String phone;
  Contact({required this.name, required this.phone});
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Contact> _contacts = [
    Contact(name: 'Mom', phone: '+7 777 123 4567'),
    Contact(name: 'Best Friend', phone: '+7 777 765 4321'),
  ];

  void _addContact() async {
    String name = '';
    String phone = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFE0F7),
        title: const Text('Add Contact', style: TextStyle(color: Color(0xFFB23A48), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => name = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              onChanged: (v) => phone = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA6C9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (name.trim().isNotEmpty && phone.trim().isNotEmpty) {
                setState(() {
                  _contacts.add(Contact(name: name.trim(), phone: phone.trim()));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(int index) async {
    String confirm = '';
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFE0F7),
        title: const Text('Delete Contact', style: TextStyle(color: Color(0xFFB23A48), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Type YES to confirm deletion:', style: TextStyle(color: Color(0xFFB23A48))),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => confirm = v,
              decoration: const InputDecoration(hintText: 'Type YES'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA6C9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (confirm.trim().toUpperCase() == 'YES') {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (result == true) {
      setState(() {
        _contacts.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        backgroundColor: const Color(0xFFFBC2EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF18171C),
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _contacts.length,
          separatorBuilder: (context, i) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final contact = _contacts[index];
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE0F7), Color(0xFFFBC2EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBC2EB).withOpacity(0.13),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFA6C9),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(contact.name, style: const TextStyle(color: Color(0xFFB23A48), fontWeight: FontWeight.bold, fontFamily: 'ComicNeue')),
                subtitle: Text(contact.phone, style: const TextStyle(color: Color(0xFFB23A48), fontFamily: 'ComicNeue')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, color: Color(0xFFB23A48)),
                      onPressed: () {
                        // TODO: Implement call functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFB23A48)),
                      onPressed: () => _deleteContact(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFBC2EB),
        foregroundColor: Colors.white,
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 3),
    );
  }
} 