import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class VoiceSearchButton extends StatefulWidget {
  final Function(String) onVoiceSearch; // Callback to pass search query

  const VoiceSearchButton({super.key, required this.onVoiceSearch});

  @override
  State<VoiceSearchButton> createState() => _VoiceSearchButtonState();
}

class _VoiceSearchButtonState extends State<VoiceSearchButton> {
  final SpeechToText _speechToText = SpeechToText();
  // ignore: unused_field
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    // if (kIsWeb) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //           content: Text(
    //               'Voice search is not supported on web. Please use a mobile device')
    //       )
    //   );
    //   return;
    // }

    await _speechToText.listen(
      onResult: _onSpeechResult,
    );
    setState(() {
      _lastWords = '';
    });
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    if (_lastWords.isNotEmpty) {
      widget.onVoiceSearch(_lastWords);
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (result.finalResult) {
        widget.onVoiceSearch(_lastWords); // pass the final result to parent
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic),
      onPressed: _speechToText.isListening
          ? _stopListening
          : _startListening, // Toggle listening state
    );
  }
}