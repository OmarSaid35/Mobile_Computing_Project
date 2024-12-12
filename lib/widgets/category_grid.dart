import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/utils/constants.dart';
import 'package:scratch_ecommerce/widgets/error_message.dart';
import 'package:scratch_ecommerce/widgets/loading_indicator.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<Map<String, String>> staticCategories = [
    {
      'id': '1',
      'name': 'Electronics',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '2',
      'name': 'Fashion',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '3',
      'name': 'Home Appliances',
      'imageUrl': 'https://via.placeholder.com/150',
    },
    {
      'id': '4',
      'name': 'Books',
      'imageUrl': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const bool isLoading = false;

    // ignore: dead_code
    if (isLoading) {
      return const LoadingIndicator();
    }

    if (staticCategories.isEmpty) {
      return const ErrorMessage(
        message: 'No categories available.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: staticCategories.length,
      itemBuilder: (context, index) {
        final category = staticCategories[index];
        return CategoryCard(
          name: category['name']!,
          imageUrl: category['imageUrl']!,
          onTap: () => Navigator.pushNamed(
            context,
            AppConstants.productListRoute,
            arguments: {
              'categoryId': category['id'],
              'categoryName': category['name'],
            },
          ),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
