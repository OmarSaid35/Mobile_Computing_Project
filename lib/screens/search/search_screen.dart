import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/screens/search/barcode_scanner_button.dart';
import 'package:scratch_ecommerce/screens/search/voice_search_button.dart';
import 'package:scratch_ecommerce/widgets/product_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final snapshot = await _firestore.collection('categories').get();
      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> categories = snapshot.docs
            .map((doc) => {'id': doc.get('id'), 'name': doc.data()['name']})
            .toList();

        categories.insert(0, {'id': 'All', 'name': 'All'});

        setState(() {
          _categories = categories;
          _selectedCategory = categories[0]['id'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoading = false;
      });
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

  void _handleCategoryChange(String? value) {
    setState(() {
      _selectedCategory = value;
    });
     print("Selected category id: $value");
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
         Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Select Category'),
                items: _categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category['id'],
                          child: Text(category['name'] ?? ''),
                        ))
                    .toList(),
                onChanged: _handleCategoryChange,
              ),
              const SizedBox(height: 16), 
  
                Row(
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
                ],
                ),
                ),
          Expanded(
            child: ProductGrid(
              searchQuery: _searchQuery,
              categoryId: _selectedCategory,
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