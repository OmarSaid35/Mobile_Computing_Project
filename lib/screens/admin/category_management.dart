import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/models/category_model.dart';

class CategoryManagement extends StatefulWidget {
  const CategoryManagement({super.key});

  @override
  State<CategoryManagement> createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagement> {
  final List<Category> categories = [
    Category(id: '1',
    name: "Books",
    imageUrl: 'https://via.placeholder.com/150'),
  ];

  void showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
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
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty &&
                    imageUrlController.text.isNotEmpty) {
                  setState(() {
                    categories.add(
                      Category(
                        id: idController.text,
                        name: nameController.text,
                        imageUrl: imageUrlController.text,        
                      ),
                    );
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

  void showEditCategoryDialog(BuildContext context, Category category) {
    final idController = TextEditingController(text: category.id);
    final nameController = TextEditingController(text: category.name);
    final imageUrlController = TextEditingController(text: category.imageUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
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
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty &&
                    imageUrlController.text.isNotEmpty) {
                  setState(() {
                    final updatedProduct = Category(
                      id: idController.text,
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                    );
                    final index = categories.indexWhere((p) => p.id == category.id);
                    if (index != -1) {
                      categories[index] = updatedProduct;
                    }
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
    return ListView.builder(
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => showAddCategoryDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Category'),
            ),
          );
        }

        final category = categories[index - 1];

        return ListTile(
          leading: Image.network(
            category.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(category.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${category.id}'),
              //Text('Name: ${category.name}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showEditCategoryDialog(context, category),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    categories.remove(category);
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