import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductGrid extends StatelessWidget {
  final String searchQuery;
  final String? categoryId;

  const ProductGrid({
    super.key,
    required this.searchQuery,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    // Construct Firestore query based on searchQuery and categoryId
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('product');

    if (categoryId != null && categoryId!.isNotEmpty) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }
    if (searchQuery.isNotEmpty) {
      query = query.where('name', isGreaterThanOrEqualTo: searchQuery).where(
            'name',
            isLessThanOrEqualTo: '$searchQuery\uf8ff',
          );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found.'));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index].data();
            return Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      product['picUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
