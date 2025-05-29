import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SafePlace {
  final String id;
  final String name;
  final String address;
  final String type;
  final LatLng location;
  final String? phoneNumber;
  final String? website;
  final bool isOpen24Hours;

  SafePlace({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.location,
    this.phoneNumber,
    this.website,
    this.isOpen24Hours = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'type': type,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'phoneNumber': phoneNumber,
      'website': website,
      'isOpen24Hours': isOpen24Hours,
    };
  }

  factory SafePlace.fromMap(String id, Map<String, dynamic> map) {
    return SafePlace(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      location: LatLng(
        map['latitude'] ?? 0.0,
        map['longitude'] ?? 0.0,
      ),
      phoneNumber: map['phoneNumber'],
      website: map['website'],
      isOpen24Hours: map['isOpen24Hours'] ?? false,
    );
  }
}

class SafePlacesScreen extends StatefulWidget {
  const SafePlacesScreen({super.key});

  @override
  State<SafePlacesScreen> createState() => _SafePlacesScreenState();
}

class _SafePlacesScreenState extends State<SafePlacesScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;
  String _selectedType = 'All';
  final List<String> _placeTypes = [
    'All',
    'Police Station',
    'Hospital',
    'Fire Station',
    'Shelter',
    'Community Center',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationService =
          Provider.of<LocationService>(context, listen: false);
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        _mapController.move(_currentLocation!, 15.0);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Place Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _placeTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentLocation ?? const LatLng(0, 0),
                          initialZoom: 15.0,
                          onTap: (_, __) {},
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.bestiehere.app',
                          ),
                          if (_currentLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentLocation!,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.my_location,
                                    color: AppTheme.primaryColor,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('safe_places')
                                .where('type',
                                    isEqualTo: _selectedType == 'All'
                                        ? null
                                        : _selectedType)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final places = snapshot.data?.docs.map((doc) {
                                    return SafePlace.fromMap(
                                      doc.id,
                                      doc.data() as Map<String, dynamic>,
                                    );
                                  }).toList() ??
                                  [];

                              return MarkerLayer(
                                markers: places.map((place) {
                                  return Marker(
                                    point: place.location,
                                    width: 40,
                                    height: 40,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              SafePlaceDetails(
                                            place: place,
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        _getPlaceIcon(place.type),
                                        color: AppTheme.primaryColor,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: FloatingActionButton(
                          onPressed: _getCurrentLocation,
                          child: const Icon(Icons.my_location),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'police station':
        return Icons.local_police;
      case 'hospital':
        return Icons.local_hospital;
      case 'fire station':
        return Icons.fire_truck;
      case 'shelter':
        return Icons.home;
      case 'community center':
        return Icons.people;
      default:
        return Icons.place;
    }
  }
}

class SafePlaceDetails extends StatelessWidget {
  final SafePlace place;

  const SafePlaceDetails({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getPlaceIcon(place.type),
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      place.type,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Address',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(place.address),
          if (place.phoneNumber != null) ...[
            const SizedBox(height: 16),
            Text(
              'Phone',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement phone call
              },
              icon: const Icon(Icons.phone),
              label: Text(place.phoneNumber!),
            ),
          ],
          if (place.website != null) ...[
            const SizedBox(height: 16),
            Text(
              'Website',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement website opening
              },
              icon: const Icon(Icons.language),
              label: Text(place.website!),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: place.isOpen24Hours ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                place.isOpen24Hours ? 'Open 24/7' : 'Check hours',
                style: TextStyle(
                  color: place.isOpen24Hours ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement navigation
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPlaceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'police station':
        return Icons.local_police;
      case 'hospital':
        return Icons.local_hospital;
      case 'fire station':
        return Icons.fire_truck;
      case 'shelter':
        return Icons.home;
      case 'community center':
        return Icons.people;
      default:
        return Icons.place;
    }
  }
}
