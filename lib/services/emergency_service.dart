import 'package:url_launcher/url_launcher.dart';

class EmergencyService {
  Future<void> triggerEmergencyCall() async {
    const emergencyNumber = '112'; // Emergency number for Kazakhstan
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: emergencyNumber,
    );
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw Exception('Could not launch emergency call');
    }
  }

  Future<void> sendEmergencySMS(String message) async {
    const emergencyNumber = '112';
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: emergencyNumber,
      queryParameters: {'body': message},
    );
    
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw Exception('Could not launch SMS');
    }
  }
} 