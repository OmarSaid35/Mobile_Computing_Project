class ProductModel {
  String _id;
  String _name;
  double _price;
  String _category;
  int _stockQuantity;
  String _imageUrl;
  double _rating;
  int _soldCount;

  ProductModel({
    required String id,
    required String name,
    required double price,
    required String category,
    required int stockQuantity,
    required String imageUrl,
    double rating = 0.0,
    int soldCount = 0,
  })  : _id = id,
        _name = name,
        _price = price,
        _category = category,
        _stockQuantity = stockQuantity,
        _imageUrl = imageUrl,
        _rating = rating,
        _soldCount = soldCount;

  // Getters
  String get id => _id;
  String get name => _name;
  double get price => _price;
  String get category => _category;
  int get stockQuantity => _stockQuantity;
  String get imageUrl => _imageUrl;
  double get rating => _rating;
  int get soldCount => _soldCount;

  // Setters
  set id(String value) => _id = value;
  set name(String value) => _name = value;
  set price(double value) => _price = value;
  set category(String value) => _category = value;
  set stockQuantity(int value) => _stockQuantity = value;
  set imageUrl(String value) => _imageUrl = value;
  set rating(double value) => _rating = value;
  set soldCount(int value) => _soldCount = value;

  factory ProductModel.fromJson(Map<String, dynamic> json, String documentId) {
      return ProductModel(
      id: documentId,  // Using documentId from QueryDocumentSnapshot
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['categoryId'] ?? '',
      stockQuantity: (json['quantity'] as num?)?.toInt() ?? 0,
      imageUrl: json['picUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      soldCount: (json['sales'] as num?)?.toInt() ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'price': _price,
      'category': _category,
      'stockQuantity': _stockQuantity,
      'imageUrl': _imageUrl,
      'rating': _rating,
      'soldCount': _soldCount,
    };
  }
}