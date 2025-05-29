import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/voice_recognition_service.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});

  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  final VoiceRecognitionService _voiceService = VoiceRecognitionService();
  String _recognizedText = '';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeVoiceRecognition();
  }

  Future<void> _initializeVoiceRecognition() async {
    await _voiceService.initialize();
  }

  Future<void> _startVoiceRecognition() async {
    try {
      setState(() => _isListening = true);
      final text = await _voiceService.startListening();
      setState(() {
        _recognizedText = text;
        _isListening = false;
      });
    } catch (e) {
      setState(() => _isListening = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _stopVoiceRecognition() async {
    await _voiceService.stopListening();
    setState(() => _isListening = false);
  }

  Future<void> _callEmergency() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '112',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: _callEmergency,
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
            // Trusted Contacts
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trusted Contacts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text('Mom'),
                        subtitle: Text('+7 777 123 4567'),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text('Best Friend'),
                        subtitle: Text('+7 777 765 4321'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Gesture Recognition
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gesture Recognition',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Shake your phone three times to send an emergency alert to your trusted contacts.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
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
            const SizedBox(height: 20),
            // Safe Places
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe Places',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.local_police),
                        title: Text('Police Station'),
                        subtitle: Text('Nearest police station'),
                      ),
                      ListTile(
                        leading: Icon(Icons.local_hospital),
                        title: Text('Hospital'),
                        subtitle: Text('Nearest hospital'),
                      ),
                      ListTile(
                        leading: Icon(Icons.security),
                        title: Text('Women\'s Shelter'),
                        subtitle: Text('Safe shelter locations'),
                      ),
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
