import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String picUrl; // Image URL for the category
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.picUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: picUrl.isNotEmpty
                    ? Image.network(picUrl, fit: BoxFit.cover)
                    : const Icon(Icons
                        .image_not_supported), // Display a default icon if the image URL is empty
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
