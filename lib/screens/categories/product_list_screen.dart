import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/models/product_model.dart';
//import 'package:scratch_ecommerce/screens/checkout/widgets/product_card.dart';
import 'package:scratch_ecommerce/widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  // Static product list for testing
  static const List<Map<String, dynamic>> staticProducts = [
    {
      'id': '1',
      'name': 'Smartphone',
      'description': 'A high-end smartphone with great features',
      'price': 999.99,
      'category': 'electronics',
      'stockQuantity': 10,
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.5,
      'soldCount': 100,
    },
    {
      'id': '2',
      'name': 'Laptop',
      'description': 'A powerful laptop for work and play',
      'price': 1499.99,
      'category': 'electronics',
      'stockQuantity': 5,
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.8,
      'soldCount': 50,
    },
    {
      'id': '3',
      'name': 'Headphones',
      'description': 'Noise-cancelling headphones',
      'price': 199.99,
      'category': 'electronics',
      'stockQuantity': 15,
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.2,
      'soldCount': 75,
    },
    {
      'id': '4',
      'name': 'Smartwatch',
      'description': 'Track your fitness and stay connected',
      'price': 299.99,
      'category': 'electronics',
      'stockQuantity': 20,
      'imageUrl': 'https://via.placeholder.com/150',
      'rating': 4.7,
      'soldCount': 30,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter static products by categoryId
    final filteredProducts = staticProducts
        .where((product) => product['category'] == categoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: filteredProducts.isEmpty
          ? const Center(child: Text('No products available in this category'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = ProductModel.fromJson(filteredProducts[index]);
                return ProductCard(product: product);
              },
            ),
    );
  }
}
