import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/location_service.dart';
import '../widgets/bestie_bottom_nav_bar.dart';

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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.9),
              AppTheme.secondaryColor.withOpacity(0.9),
            ],
          ),
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
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Share Location',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.telegram, color: Color(0xFF0088CC)),
              title: const Text('Share on Telegram'),
              textColor: Colors.white,
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
              textColor: Colors.white,
              onTap: () async {
                final url = Uri.parse('https://wa.me/?text=My current location: $locationUrl');
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
                  color: Color(0xFFE1306C),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'IG',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              title: const Text('Share on Instagram'),
              textColor: Colors.white,
              onTap: () async {
                final url = Uri.parse('https://www.instagram.com/yeeeerkhan/');
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
                  color: Color(0xFF0077B5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'in',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              title: const Text('Share on LinkedIn'),
              textColor: Colors.white,
              onTap: () async {
                final url = Uri.parse('https://www.linkedin.com/in/liana-smatulla-382835360/');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy, color: Colors.white),
              title: const Text('Copy Location Link'),
              textColor: Colors.white,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundColor,
              Colors.white,
            ],
          ),
        ),
        child: Stack(
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
      ),
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 1),
    );
  }
} 