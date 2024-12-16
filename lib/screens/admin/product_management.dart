import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scratch_ecommerce/models/product_model.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({super.key});

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void showAddProductDialog(
      BuildContext context, List<Map<String, String>> categories) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageUrlController = TextEditingController();
    final quantityController = TextEditingController();

    String? selectedCategoryId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  hint: const Text('Category'),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category['id'],
                            child: Text(category['name']!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedCategoryId != null &&
                    double.tryParse(priceController.text) != null &&
                    int.tryParse(quantityController.text) != null &&
                    imageUrlController.text.isNotEmpty) {
                  await _firestore.collection('product').add({
                    'name': nameController.text,
                    'categoryId': selectedCategoryId,
                    'price': double.parse(priceController.text),
                    'quantity': int.parse(quantityController.text),
                    'picUrl': imageUrlController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditProductDialog(BuildContext context, ProductModel product,
      List<Map<String, String>> categories) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toString());
    final imageUrlController = TextEditingController(text: product.imageUrl);
    final quantityController =
        TextEditingController(text: product.stockQuantity.toString());

    String? selectedCategoryId = product.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  hint: const Text('Category'),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category['id'],
                            child: Text(category['name']!),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                    });
                  },
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    selectedCategoryId != null &&
                    double.tryParse(priceController.text) != null &&
                    int.tryParse(quantityController.text) != null &&
                    imageUrlController.text.isNotEmpty) {
                  await _firestore
                      .collection('product')
                      .doc(product.id)
                      .update({
                    'name': nameController.text,
                    'categoryId': selectedCategoryId,
                    'price': double.parse(priceController.text),
                    'quantity': int.parse(quantityController.text),
                    'picUrl': imageUrlController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('categories').snapshots(),
      builder: (context, categoriesSnapshot) {
        if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = categoriesSnapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': data['id'].toString(), // Ensure 'id' is a String
            'name': data['name'].toString(), // Ensure 'name' is a String
          };
        }).toList();

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('product').snapshots(),
          builder: (context, productsSnapshot) {
            if (productsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = productsSnapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ProductModel(
                id: doc.id,
                name: data['name'],
                price: data['price'],
                category: data['categoryId'],
                stockQuantity: data['quantity'],
                imageUrl: data['picUrl'],
                soldCount: data['soldCount'] ?? 0,
              );
            }).toList();

            return ListView.builder(
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          showAddProductDialog(context, categories),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Product'),
                    ),
                  );
                }

                final product = products[index - 1];

                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category ID: ${product.category}'),
                      Text('Stock Quantity: ${product.stockQuantity}'),
                      Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            showEditProductDialog(context, product, categories),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _firestore
                              .collection('product')
                              .doc(product.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
