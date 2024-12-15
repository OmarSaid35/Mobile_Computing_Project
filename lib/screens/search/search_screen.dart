import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/screens/search/barcode_scanner_button.dart';
import 'package:scratch_ecommerce/screens/search/voice_search_button.dart';
import 'package:scratch_ecommerce/widgets/product_grid.dart';

class SearchScreen extends StatefulWidget {
  final String? categoryId; // Accept categoryId as an optional parameter

  const SearchScreen({super.key, this.categoryId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      // Use categoryId as the initial filter if provided
      _searchQuery = widget.categoryId!;
    }
  }

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
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      border: OutlineInputBorder(),
                    ),
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
            child: ProductGrid(
              searchQuery: _searchQuery,
              categoryId: widget.categoryId, // Pass categoryId to ProductGrid
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
