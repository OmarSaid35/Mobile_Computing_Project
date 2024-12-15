import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/screens/search/barcode_scanner_button.dart';
import 'package:scratch_ecommerce/screens/search/voice_search_button.dart';
import 'package:scratch_ecommerce/widgets/product_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  void _handleBarcodeScan(String barcode) {
    setState(() {
      _searchController.text = barcode;
      _searchQuery = barcode;
    });
  }

  void _handleVoiceSearch(String text) {
     setState(() {
      _searchController.text = text;
       _searchQuery = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(width: 8),
              VoiceSearchButton(onVoiceSearch: _handleVoiceSearch),
              const SizedBox(width: 8),
              BarcodeScannerButton(onBarcodeScanned: _handleBarcodeScan),
            ],
          ),
        ),
        Expanded(
          child: ProductGrid(searchQuery: _searchQuery),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}