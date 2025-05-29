import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../widgets/bestie_bottom_nav_bar.dart';

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
  final MapController _mapController = MapController();
  Position? _currentPosition;
  LatLng? _currentLatLng;
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
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _currentLatLng = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLatLng!, 14);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: \\n${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  List<Marker> get _buildMarkers {
    final markers = <Marker>[];
    if (_currentLatLng != null) {
      markers.add(
        Marker(
          point: _currentLatLng!,
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 28),
          ),
        ),
      );
    }
    for (final place in _safePlaces) {
      markers.add(
        Marker(
          point: place.location,
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFA6C9).withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFA6C9).withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.spa_rounded, color: Colors.white, size: 26),
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Places'),
        backgroundColor: const Color(0xFFFFA6C9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentLatLng == null
                ? const Center(child: CircularProgressIndicator())
                : ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _currentLatLng,
                        zoom: 14,
                        maxZoom: 18,
                        minZoom: 5,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.bestiehere.app',
                        ),
                        MarkerLayer(markers: _buildMarkers),
                      ],
                    ),
                  ),
          ),
          Container(
            height: 210,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _safePlaces.length,
              separatorBuilder: (context, i) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final place = _safePlaces[index];
                return GestureDetector(
                  onTap: () {
                    _mapController.move(place.location, 16);
                  },
                  child: Container(
                    width: 220,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE0F7), Color(0xFFFFA6C9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFA6C9).withOpacity(0.13),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.spa_rounded, color: Color(0xFFFFA6C9), size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                place.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'ComicNeue',
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFFB23A48),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          place.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'ComicNeue',
                            shadows: [
                              Shadow(
                                color: Color(0xFFB23A48),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.white, size: 18, shadows: [Shadow(color: Color(0xFFB23A48), blurRadius: 2)]),
                            const SizedBox(width: 6),
                            Text(
                              place.phoneNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'ComicNeue',
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFFB23A48),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFA6C9),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFFB23A48).withOpacity(0.2),
                            ),
                            icon: const Icon(Icons.map),
                            label: const Text('Show on Map', style: TextStyle(fontWeight: FontWeight.bold, shadows: [Shadow(color: Color(0xFFB23A48), blurRadius: 2)])),
                            onPressed: () {
                              _mapController.move(place.location, 16);
                            },
                          ),
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
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 1),
    );
  }
}
