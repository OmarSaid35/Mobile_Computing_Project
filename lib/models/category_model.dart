class Category {
  final String id;
  final String name;
  final String picUrl;

  Category({
    required this.id,
    required this.name,
    required this.picUrl,
  });

  // Factory method to create a Category from Firestore data
  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      name: data['name'] as String,
      picUrl: data['picUrl'] as String,
    );
  }
}
