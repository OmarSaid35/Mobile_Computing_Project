class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      name: data['name'] as String,
      imageUrl: data['picUrl'] as String,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
       id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['picUrl'] as String,
    );
  }

  // Updated toJson to include schoolName
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'picUrl':imageUrl
    };
  }
}
