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
              const VoiceSearchButton(),
              const SizedBox(width: 8),
              const BarcodeScannerButton(),
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