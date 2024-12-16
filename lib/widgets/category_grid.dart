import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scratch_ecommerce/models/category_model.dart';
import 'package:scratch_ecommerce/screens/categories/category_card.dart';
import 'package:scratch_ecommerce/widgets/loading_indicator.dart';
import 'package:scratch_ecommerce/widgets/error_message.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  Future<List<Category>> fetchCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      return querySnapshot.docs
          .map((doc) => Category.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw 'Failed to load categories: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        if (snapshot.hasError) {
          return ErrorMessage(message: snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const ErrorMessage(message: 'No categories available.');
        }

        final categories = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              name: category.name,
              picUrl: category.imageUrl,
              onTap: () {
                // Handle navigation or action on category tap
                print('Tapped on category: ${category.name}');
              },
            );
          },
        );
      },
    );
  }
}
