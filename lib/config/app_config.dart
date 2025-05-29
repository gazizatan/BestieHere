class AppConfig {
  // Map API Keys
  // Using OpenStreetMap (free) instead of Mapbox
  static const String openStreetMapUserAgent = 'com.bestiehere.app';
  static const String openStreetMapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Emergency Services (Kazakhstan)
  static const String emergencyNumber = '102';
  static const String ambulanceNumber = '103';
  static const String fireDepartmentNumber = '101';

  // API Endpoints
  // Using mock data for now since we don't have a backend
  static const String baseApiUrl = 'https://api.bestiehere.com';
  static const String safePlacesEndpoint = '/api/safe-places';
  static const String emergencyContactsEndpoint = '/api/emergency-contacts';

  // Feature Flags
  static const bool enableVoiceRecognition = true;
  static const bool enableLocationTracking = true;
  static const bool enableEmergencyCalls = true;

  // App Settings
  static const int locationUpdateInterval = 30; // seconds
  static const int emergencyCallTimeout = 30; // seconds
  static const double defaultMapZoom = 13.0;
  static const double maxSafePlaceDistance = 5.0; // kilometers

  // Safe Places Data (mock data for now)
  static const List<Map<String, dynamic>> mockSafePlaces = [
    {
      'name': 'Crisis Center for Women',
      'nameKz': 'Әйелдер дағдарысы орталығы',
      'nameRu': 'Кризисный центр для женщин',
      'description':
          'Provides shelter and support for women in crisis situations',
      'address': 'Almaty, Tole Bi 59',
      'workingHours': '24/7',
      'phoneNumber': '+7 (727) 123-4567',
      'location': {'latitude': 43.2220, 'longitude': 76.8512},
    },
    {
      'name': 'Aman Saulyk Foundation',
      'nameKz': 'Аман Саулық қоры',
      'nameRu': 'Фонд Аман Саулык',
      'description': 'Healthcare and medical support for women',
      'address': 'Almaty, Furmanov 187',
      'workingHours': 'Mon-Fri 9:00-18:00',
      'phoneNumber': '+7 (727) 234-5678',
      'location': {'latitude': 43.2389, 'longitude': 76.8897},
    },
  ];

  // Emergency Contacts (mock data for now)
  static const List<Map<String, dynamic>> mockEmergencyContacts = [
    {
      'name': 'Emergency Services',
      'description': 'Police, Ambulance, Fire Department',
      'phoneNumber': '102',
      'category': 'Emergency',
    },
    {
      'name': 'Women\'s Crisis Hotline',
      'description': '24/7 support for women in crisis',
      'phoneNumber': '+7 (727) 123-4567',
      'category': 'Support',
    },
  ];
}
