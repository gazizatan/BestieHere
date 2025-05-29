import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;
  final String? telegramUsername;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.telegramUsername,
  });
}

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<EmergencyContact> _contacts = [
    EmergencyContact(
      name: 'Mom',
      phoneNumber: '+7 777 123 4567',
      relationship: 'Family',
      telegramUsername: 'mom_telegram',
    ),
    EmergencyContact(
      name: 'Best Friend',
      phoneNumber: '+7 777 765 4321',
      relationship: 'Friend',
      telegramUsername: 'qazintelligence',
    ),
  ];

  void _addContact() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ContactForm(
        onSave: (contact) {
          setState(() {
            _contacts.add(contact);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _editContact(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ContactForm(
        contact: _contacts[index],
        onSave: (contact) {
          setState(() {
            _contacts[index] = contact;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${_contacts[index].name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _contacts.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchTelegram(String username) async {
    final url = Uri.parse('https://t.me/$username');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Telegram')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            final contact = _contacts[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppTheme.primaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        contact.phoneNumber,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        contact.relationship,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone),
                        color: AppTheme.primaryColor,
                        onPressed: () async {
                          final url = Uri.parse('tel:${contact.phoneNumber}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      ),
                      if (contact.telegramUsername != null)
                        IconButton(
                          icon: const Icon(Icons.telegram),
                          color: AppTheme.primaryColor,
                          onPressed: () => _launchTelegram(contact.telegramUsername!),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: AppTheme.primaryColor,
                        onPressed: () => _editContact(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppTheme.errorColor,
                        onPressed: () => _deleteContact(index),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Contacts tab index
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
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
            icon: Icon(Icons.people),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
              // Already on contacts screen
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  final EmergencyContact? contact;
  final Function(EmergencyContact) onSave;

  const _ContactForm({
    this.contact,
    required this.onSave,
  });

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _relationshipController;
  late TextEditingController _telegramController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name);
    _phoneController = TextEditingController(text: widget.contact?.phoneNumber);
    _relationshipController = TextEditingController(text: widget.contact?.relationship);
    _telegramController = TextEditingController(text: widget.contact?.telegramUsername);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    _telegramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.contact == null ? 'Add Contact' : 'Edit Contact',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a relationship';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telegramController,
                decoration: const InputDecoration(
                  labelText: 'Telegram Username (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      EmergencyContact(
                        name: _nameController.text,
                        phoneNumber: _phoneController.text,
                        relationship: _relationshipController.text,
                        telegramUsername: _telegramController.text.isEmpty
                            ? null
                            : _telegramController.text,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  widget.contact == null ? 'Add Contact' : 'Save Changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
