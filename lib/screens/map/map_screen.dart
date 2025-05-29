import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  // Safe places in Kazakhstan (example coordinates)
  final List<Map<String, dynamic>> _safePlaces = [
    {
      'name': 'Police Station',
      'lat': 43.2220,
      'lng': 76.8512,
      'type': 'police',
    },
    {
      'name': 'Women\'s Shelter',
      'lat': 43.2389,
      'lng': 76.8897,
      'type': 'shelter',
    },
    {
      'name': 'Hospital',
      'lat': 43.2567,
      'lng': 76.9286,
      'type': 'hospital',
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addSafePlaceMarkers();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  void _addSafePlaceMarkers() {
    for (var place in _safePlaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(place['name']),
          position: LatLng(place['lat'], place['lng']),
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: 'Tap for more information',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            place['type'] == 'police'
                ? BitmapDescriptor.hueBlue
                : place['type'] == 'hospital'
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
              ),
            );
          }
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
