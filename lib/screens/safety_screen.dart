import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/emergency_contact.dart';
import '../models/safe_place.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  Position? _currentPosition;
  bool _isTracking = false;
  final MapController _mapController = MapController();
  LatLng? _currentLatLng;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
          _currentLatLng = LatLng(position.latitude, position.longitude);
        });
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Safety Features',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildEmergencyButton(context),
                const SizedBox(height: 24),
                _buildEmergencyContacts(context),
                const SizedBox(height: 24),
                _buildLocationTracking(context),
                const SizedBox(height: 24),
                _buildMapView(context),
                const SizedBox(height: 24),
                _buildSafePlaces(context),
                const SizedBox(height: 24),
                _buildSafetyTips(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.emergency, color: AppTheme.accentColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Emergency SOS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _makePhoneCall('102');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Call Emergency Services'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contacts',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...EmergencyContacts.contacts
            .map((contact) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      contact.category == 'Emergency'
                          ? Icons.emergency
                          : Icons.phone,
                      color: AppTheme.primaryColor,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.description),
                    trailing: ElevatedButton(
                      onPressed: () => _makePhoneCall(contact.phoneNumber),
                      child: Text(contact.phoneNumber),
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildMapView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Safe Places',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _currentLatLng == null
                ? const Center(child: CircularProgressIndicator())
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: _currentLatLng,
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.bestiehere',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_currentLatLng != null)
                            Marker(
                              point: _currentLatLng!,
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_on,
                                color: AppTheme.primaryColor,
                                size: 40,
                              ),
                            ),
                          ...SafePlaces.places.map((place) => Marker(
                                point: place.location,
                                width: 80,
                                height: 80,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          _buildPlaceDetails(place),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceDetails(SafePlace place) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(place.nameKz),
          Text(place.nameRu),
          const SizedBox(height: 16),
          Text(place.description),
          const SizedBox(height: 8),
          Text('Address: ${place.address}'),
          Text('Working Hours: ${place.workingHours}'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _makePhoneCall(place.phoneNumber),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text('Call: ${place.phoneNumber}'),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTracking(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Tracking',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Share Location'),
              subtitle: Text(
                _isTracking
                    ? 'Location sharing is active'
                    : 'Location sharing is off',
              ),
              value: _isTracking,
              onChanged: (value) {
                setState(() {
                  _isTracking = value;
                });
              },
            ),
            if (_currentPosition != null) ...[
              const SizedBox(height: 16),
              Text(
                'Current Location:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Latitude: ${_currentPosition!.latitude}\nLongitude: ${_currentPosition!.longitude}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSafePlaces(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nearby Safe Places',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildSafePlaceCard(
          context,
          'Crisis Center for Women',
          '1.2 km away',
          Icons.home,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Aman Saulyk Foundation',
          '2.0 km away',
          Icons.favorite,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Kazakhstan Women\'s Union',
          '2.8 km away',
          Icons.group,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Legal Aid Center',
          '1.5 km away',
          Icons.gavel,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Psychological Support Center',
          '2.3 km away',
          Icons.psychology,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Police Station',
          '1.8 km away',
          Icons.local_police,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Hospital',
          '3.2 km away',
          Icons.local_hospital,
        ),
        const SizedBox(height: 12),
        _buildSafePlaceCard(
          context,
          'Women\'s Shelter',
          '2.5 km away',
          Icons.home,
        ),
      ],
    );
  }

  Widget _buildSafePlaceCard(
    BuildContext context,
    String title,
    String distance,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(distance),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to location
          },
          child: const Text('Directions'),
        ),
      ),
    );
  }

  Widget _buildSafetyTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Safety Tips', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildSafetyTipCard(
          context,
          'Emergency Contacts',
          'Save important emergency numbers',
          Icons.phone,
        ),
        const SizedBox(height: 12),
        _buildSafetyTipCard(
          context,
          'Safety Checklist',
          'Daily safety precautions',
          Icons.checklist,
        ),
        const SizedBox(height: 12),
        _buildSafetyTipCard(
          context,
          'Self-Defense Tips',
          'Basic self-defense techniques',
          Icons.security,
        ),
      ],
    );
  }

  Widget _buildSafetyTipCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to safety tip details
        },
      ),
    );
  }
}
