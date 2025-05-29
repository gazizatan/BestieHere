import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  Position? _currentPosition;
  final List<Marker> _markers = [];

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
        _markers.clear();
        _markers.add(
          Marker(
            point: LatLng(position.latitude, position.longitude),
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      });
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showShareOptions() {
    if (_currentPosition == null) return;

    final locationUrl = 'https://www.openstreetmap.org/?mlat=${_currentPosition!.latitude}&mlon=${_currentPosition!.longitude}#map=15/${_currentPosition!.latitude}/${_currentPosition!.longitude}';
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.telegram, color: Color(0xFF0088CC)),
              title: const Text('Share on Telegram'),
              onTap: () async {
                final url = Uri.parse('https://t.me/share/url?url=$locationUrl&text=My current location');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: const Text('Share on WhatsApp'),
              onTap: () async {
                final url = Uri.parse('https://wa.me/?text=My current location: $locationUrl');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: AppTheme.primaryColor),
              title: const Text('Copy Location Link'),
              onTap: () {
                // TODO: Implement copy to clipboard
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Location'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.bestiehere',
                    ),
                    MarkerLayer(markers: _markers),
                  ],
                ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: _getCurrentLocation,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: _showShareOptions,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Icon(Icons.share),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Map tab index
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
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // Already on map screen
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/messages');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
} 