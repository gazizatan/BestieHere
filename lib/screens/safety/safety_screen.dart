import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_theme.dart';
import '../../services/voice_recognition_service.dart';
import '../../widgets/bestie_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

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
    final theme = Provider.of<ThemeProvider>(context).theme;
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Text('Safety Features'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: theme.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33FFB6C1),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield, color: Colors.white, size: 48),
                  const SizedBox(height: 10),
                  const Text(
                    'Safety Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Emergency Call Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: _callEmergency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.red.withOpacity(0.2),
                ),
                icon: const Icon(Icons.emergency, size: 28),
                label: const Text(
                  'Emergency Call (112)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            // Voice Recognition
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: const Color(0xFF18171C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(18),
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
                              color: Colors.white,
                              fontFamily: 'ComicNeue',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isListening ? Icons.mic_off : Icons.mic,
                              color: _isListening
                                  ? Colors.red
                                  : theme.primaryColor,
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
                        style: TextStyle(fontSize: 16, color: Colors.white70, fontFamily: 'ComicNeue'),
                      ),
                      if (_recognizedText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.record_voice_over,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _recognizedText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.primaryColor,
                                    fontFamily: 'ComicNeue',
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
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            // SAFETY TIPS FOR GIRLS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Tips for Girls',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[
                    "Always trust your instincts and leave if you feel uncomfortable.",
                    "Share your location with trusted friends or family.",
                    "Avoid walking alone at night in unfamiliar areas.",
                    "Keep your phone charged and accessible.",
                    "Let someone know your plans and expected return time.",
                    "Carry a personal safety alarm or whistle.",
                    "Stay alert and avoid distractions like headphones in risky areas.",
                    "Use well-lit and busy streets whenever possible.",
                    "Don't accept rides from strangers.",
                    "If you feel followed, go to a public place or approach a group.",
                    "Keep emergency numbers on speed dial.",
                    "Be cautious when sharing personal info online.",
                    "Trust your gut about people and situations.",
                    "If using a ride service, check the car and driver details.",
                    "Keep your drink in sight at all times in public places.",
                    "Learn basic self-defense moves.",
                    "Have a code word with friends/family for emergencies.",
                    "Don't hesitate to make noise or draw attention if threatened.",
                    "If attacked, aim for sensitive areas (eyes, nose, groin).",
                    "Remember: your safety is more important than your belongings.",
                  ].map((tip) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: theme.secondaryColor.withOpacity(0.10),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.favorite, color: theme.primaryColor, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  color: theme.textColor,
                                  fontSize: 15,
                                  fontFamily: 'ComicNeue',
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 2),
    );
  }
}
