import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );
    }
    return _isInitialized;
  }

  Future<String> startListening() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Speech recognition failed to initialize');
      }
    }

    String recognizedText = '';

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        recognizedText = result.recognizedWords;
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );

    return recognizedText;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
} 