import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class BarcodeScannerButton extends StatelessWidget {
  final Function(String) onBarcodeScanned;

  const BarcodeScannerButton({super.key, required this.onBarcodeScanned});


  Future<void> _scanBarcode(BuildContext context) async {
    if(kIsWeb){ // Use kIsWeb
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Barcode scanning is not supported on web. Please use a mobile device')));
    }
    else {
      String barcodeScanRes;
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'Cancel',
          true,
          ScanMode.BARCODE,
        );
        if (barcodeScanRes != '-1') {
          onBarcodeScanned(barcodeScanRes);
        }
      } catch (e) {
        print('Barcode Scanner Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Could not Scan Barcode')));
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.qr_code_scanner),
      onPressed: () {
        _scanBarcode(context);
      },
    );
  }
}