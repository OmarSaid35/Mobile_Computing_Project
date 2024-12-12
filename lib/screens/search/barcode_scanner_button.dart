import 'package:flutter/material.dart';

class BarcodeScannerButton extends StatelessWidget {
  const BarcodeScannerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code_scanner),
      onPressed: () {
        // Implement barcode scanner functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Barcode scanner coming soon!')),
        );
      },
    );
  }
}