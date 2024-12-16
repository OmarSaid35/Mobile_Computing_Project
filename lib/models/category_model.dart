class Category {
  final String id;
  final String name;
<<<<<<< HEAD
  final String imageUrl;
=======
  final String picUrl;
>>>>>>> 847e2d50bb8ea46e191425841f961f1706c19f1e

  Category({
    required this.id,
    required this.name,
<<<<<<< HEAD
    required this.imageUrl,
=======
    required this.picUrl,
>>>>>>> 847e2d50bb8ea46e191425841f961f1706c19f1e
  });

  // Factory method to create a Category from Firestore data
  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      name: data['name'] as String,
<<<<<<< HEAD
      imageUrl: data['picUrl'] as String,
=======
      picUrl: data['picUrl'] as String,
>>>>>>> 847e2d50bb8ea46e191425841f961f1706c19f1e
    );
  }
}
