import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/models/product_model.dart';
import 'package:scratch_ecommerce/providers/cart_provider.dart';

class ProductGrid extends StatelessWidget {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? searchQuery;
  final String? categoryId;

  const ProductGrid({
    super.key,
    this.searchQuery,
    this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
  //   Query<Map<String, dynamic>> query =
  //       _firestore.collection('product');

  //   if (categoryId != null && categoryId != 'All') {
  //     print("Selected category id in product grid : $categoryId");//prinrt correct
  //     query = query.where('categoryId', isEqualTo: categoryId);
  //     print("Selected category id in product grid query : $query");//dont print

  //     query.get().then((snapshot) {
  //   print("Documents fetched for categoryId '$categoryId':");
  //   for (var doc in snapshot.docs) {
  //     print(doc.data());
  //   }
  // }).catchError((error) {
  //   print("Error fetching query results: $error");
  // });
  //   }

  //   if (searchQuery != null && searchQuery!.isNotEmpty) {
  //     query = query.where('name', isGreaterThanOrEqualTo: searchQuery).where(
  //           'name',
  //           isLessThanOrEqualTo: '$searchQuery\uf8ff',
  //         );
  //   }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: _firestore.collection('product').snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    // Map Firestore documents to ProductModel instances
    var products = snapshot.data!.docs.map((doc) {
      final productData = doc.data();
      return ProductModel(
        id: doc.id,
        name: productData['name'] ?? '',
        price: (productData['price'] as num?)?.toDouble() ?? 0.0,
        category: productData['categoryId'] ?? '',
        stockQuantity: (productData['quantity'] as num?)?.toInt() ?? 0,
        imageUrl: productData['picUrl'] ?? '',
        rating: (productData['rating'] as num?)?.toDouble() ?? 0.0,
        soldCount: (productData['sales'] as num?)?.toInt() ?? 0,
      );
    }).toList();

    // Apply manual filtering by categoryId
    if (categoryId != 'All') {
      print("Products lenght: ${products.length}");
      for(var i = 0; i < products.length; i++) {
        print(products[i].category);
      }
      print("Filtering products by categoryId: $categoryId");
      products = products.where((product) => product.category == categoryId).toList();
      print("Products lenght: ${products.length}");
      for(var i = 0; i < products.length; i++) {
        print(products[i].category);
      }
    }

    // Apply manual filtering by searchQuery
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      print("Filtering products by searchQuery: $searchQuery");
      products = products
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery!.toLowerCase()))
          .toList();
    }

    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the product image
              Expanded(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Display the product name
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              // Display the product price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Add to Cart button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text('Add to Cart'),
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