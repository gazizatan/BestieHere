import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/emergency_contact.dart';
import '../models/safe_place.dart';
import '../services/voice_recognition_service.dart';
import '../services/emergency_service.dart';

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
  final VoiceRecognitionService _voiceService = VoiceRecognitionService();
  final EmergencyService _emergencyService = EmergencyService();
  String _recognizedText = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeVoiceRecognition();
  }

  Future<void> _initializeVoiceRecognition() async {
    try {
      final initialized = await _voiceService.initialize();
      if (!initialized && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize voice recognition'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startVoiceRecognition() async {
    try {
      setState(() => _isListening = true);
      final text = await _voiceService.startListening();
      setState(() {
        _recognizedText = text;
        _isListening = false;
      });
      
      if (text.toLowerCase().contains('help') ||
          text.toLowerCase().contains('emergency') ||
          text.toLowerCase().contains('sos')) {
        await _triggerEmergency();
      }
    } catch (e) {
      setState(() => _isListening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _stopVoiceRecognition() async {
    await _voiceService.stopListening();
    setState(() => _isListening = false);
  }

  Future<void> _triggerEmergency() async {
    try {
      await _emergencyService.triggerEmergencyCall();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency services have been contacted'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
      appBar: AppBar(
        title: const Text('Safety Features'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppTheme.primaryColor,
              child: const Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Safety Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Emergency Call Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: _triggerEmergency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency),
                    SizedBox(width: 10),
                    Text(
                      'Emergency Call (112)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Voice Recognition
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Voice Recognition',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic_off : Icons.mic,
                              color: _isListening
                                  ? AppTheme.errorColor
                                  : AppTheme.primaryColor,
                            ),
                            onPressed: _isListening
                                ? _stopVoiceRecognition
                                : _startVoiceRecognition,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap the microphone icon to start voice recognition. Say "help" or "emergency" to trigger an alert.',
                        style: TextStyle(fontSize: 16),
                      ),
                      if (_recognizedText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.record_voice_over,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _recognizedText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
