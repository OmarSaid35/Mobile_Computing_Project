import 'package:flutter/material.dart';

class VoiceSearchButton extends StatelessWidget {
  const VoiceSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mic),
      onPressed: () {
        // Implement voice search functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Voice search coming soon!')),
        );
      },
    );
  }
}