class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String description;
  final String category;

  const EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.category,
  });
}

class EmergencyContacts {
  static const List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'Police',
      phoneNumber: '102',
      description: 'Emergency police services',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Ambulance',
      phoneNumber: '103',
      description: 'Emergency medical services',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Fire Department',
      phoneNumber: '101',
      description: 'Emergency fire services',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Domestic Violence Hotline',
      phoneNumber: '1506',
      description: '24/7 support for domestic violence victims',
      category: 'Support',
    ),
    EmergencyContact(
      name: 'Crisis Center Hotline',
      phoneNumber: '8-800-080-7777',
      description: 'Psychological support and crisis intervention',
      category: 'Support',
    ),
    EmergencyContact(
      name: 'Women\'s Rights Center',
      phoneNumber: '8-727-273-77-77',
      description: 'Legal support and women\'s rights protection',
      category: 'Legal',
    ),
    EmergencyContact(
      name: 'Child Protection Services',
      phoneNumber: '8-800-080-7788',
      description: 'Child protection and family support',
      category: 'Support',
    ),
    EmergencyContact(
      name: 'Anti-Corruption Service',
      phoneNumber: '8-800-080-7789',
      description: 'Report corruption and illegal activities',
      category: 'Legal',
    ),
  ];
}
