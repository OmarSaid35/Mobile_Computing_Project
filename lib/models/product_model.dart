class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final int stockQuantity;
  final int soldCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.stockQuantity,
    required this.soldCount,
  });

  // fromJson method to map the Firestore document data to ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      imageUrl: json['picUrl'],
      price: json['price'].toDouble(),
      stockQuantity: json['quantity'],
      soldCount: json['sales'],
    );
  }
}
