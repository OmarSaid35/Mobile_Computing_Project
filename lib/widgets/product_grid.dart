import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final String? categoryId;
  final String? searchQuery;

  const ProductGrid({
    super.key,
    this.categoryId,
    this.searchQuery,
  });

  // Static product list for testing
  static final List<ProductModel> staticProducts = [
    ProductModel(
      id: '1',
      name: 'Product A',
      description: 'Description for Product A',
      price: 29.99,
      category: 'Category1',
      stockQuantity: 10,
      imageUrl: 'https://via.placeholder.com/150',
      rating: 4.5,
      soldCount: 25,
    ),
    ProductModel(
      id: '2',
      name: 'Product B',
      description: 'Description for Product B',
      price: 49.99,
      category: 'Category2',
      stockQuantity: 5,
      imageUrl: 'https://via.placeholder.com/150',
      rating: 3.8,
      soldCount: 15,
    ),
    ProductModel(
      id: '3',
      name: 'Product C',
      description: 'Description for Product C',
      price: 19.99,
      category: 'Category1',
      stockQuantity: 8,
      imageUrl: 'https://via.placeholder.com/150',
      rating: 4.0,
      soldCount: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter products based on categoryId and searchQuery
    List<ProductModel> filteredProducts = staticProducts.where((product) {
      final matchesCategory =
          categoryId == null || product.category == categoryId;
      final matchesSearch = searchQuery == null ||
          product.name.toLowerCase().contains(searchQuery!.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(product: filteredProducts[index]);
      },
    );
  }
}
