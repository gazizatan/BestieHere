import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';

class SafePlace {
  final String name;
  final String description;
  final String phoneNumber;
  final LatLng location;

  SafePlace({
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.location,
  });
}

class SafePlacesScreen extends StatefulWidget {
  const SafePlacesScreen({super.key});

  @override
  State<SafePlacesScreen> createState() => _SafePlacesScreenState();
}

class _SafePlacesScreenState extends State<SafePlacesScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  final List<SafePlace> _safePlaces = [
    SafePlace(
      name: 'Crisis Center for Women',
      description: '24/7 support for women in crisis',
      phoneNumber: '+7 777 123 4567',
      location: const LatLng(43.2220, 76.8512),
    ),
    SafePlace(
      name: 'Aman Saulyk Foundation',
      description: 'Women\'s health and safety center',
      phoneNumber: '+7 777 234 5678',
      location: const LatLng(43.2389, 76.8897),
    ),
    SafePlace(
      name: 'Kazakhstan Women\'s Union',
      description: 'Support and advocacy center',
      phoneNumber: '+7 777 345 6789',
      location: const LatLng(43.2567, 76.9286),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addSafePlaceMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } catch (e) {
      // Handle error
    }
  }

  void _addSafePlaceMarkers() {
    for (var place in _safePlaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.name),
          position: place.location,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.description,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Places'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
          ),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _safePlaces.length,
              itemBuilder: (context, index) {
                final place = _safePlaces[index];
                return Card(
                  margin: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.phoneNumber,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                place.location,
                                15,
                              ),
                            );
                          },
                          child: const Text('Show on Map'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
