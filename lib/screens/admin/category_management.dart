import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/models/product_model.dart';

class CategoryManagement extends StatefulWidget {
  const CategoryManagement({super.key});

  @override
  State<CategoryManagement> createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  final List<ProductModel> products = [
    // ProductModel(
    //   id: '1',
    //   name: 'Product 1',
    //   price: 4.0,
    //   description: 'Sample description 1',
    //   category: 'Category 1',
    //   stockQuantity: 10,
    //   imageUrl: 'https://via.placeholder.com/150',
    // ),
    // ProductModel(
    //   id: '2',
    //   name: 'Product 2',
    //   price: 40.0,
    //   description: 'Sample description 2',
    //   category: 'Category 2',
    //   stockQuantity: 5,
    //   imageUrl: 'https://via.placeholder.com/150',
    // ),
  ];

  // void showAddProductDialog(BuildContext context) {
  //   final nameController = TextEditingController();
  //   final priceController = TextEditingController();
  //   final imageUrlController = TextEditingController();
  //   final categoryController = TextEditingController();
  //   final quantityController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Add Product'),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               TextField(
  //                 controller: nameController,
  //                 decoration: const InputDecoration(labelText: 'Name'),
  //               ),
  //               TextField(
  //                 controller: categoryController,
  //                 decoration: const InputDecoration(labelText: 'Category'),
  //               ),
  //               TextField(
  //                 controller: quantityController,
  //                 decoration: const InputDecoration(labelText: 'Quantity'),
  //               ),
  //               TextField(
  //                 controller: priceController,
  //                 decoration: const InputDecoration(labelText: 'Price'),
  //                 keyboardType: TextInputType.number,
  //               ),
  //               TextField(
  //                 controller: imageUrlController,
  //                 decoration: const InputDecoration(labelText: 'Image URL'),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               if (nameController.text.isNotEmpty &&
  //                   categoryController.text.isNotEmpty &&
  //                   double.tryParse(quantityController.text) != null &&
  //                   double.tryParse(priceController.text) != null &&
  //                   imageUrlController.text.isNotEmpty) {
  //                 setState(() {
  //                   products.add(
  //                     ProductModel(
  //                       id: DateTime.now().toString(),
  //                       name: nameController.text,
  //                       price: double.parse(priceController.text),
  //                       imageUrl: imageUrlController.text,
  //                       description: '',
  //                       category: categoryController.text,
  //                       stockQuantity: int.parse(quantityController.text),
  //                     ),
  //                   );
  //                 });
  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: const Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            // child: ElevatedButton.icon(
            //   onPressed: () => showAddProductDialog(context),
            //   icon: const Icon(Icons.add),
            //   label: const Text('Add Product'),
            // ),
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
              Text('Category: ${product.category}'),
              Text('Stock Quantity: ${product.stockQuantity}'),
              Text('Price: \$${product.price.toStringAsFixed(2)}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.edit),
              //   onPressed: () => showAddProductDialog(context),
              // ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    products.remove(product);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

}