class ProductModel {
  String _id;
  String _name;
  String _description;
  double _price;
  String _category;
  int _stockQuantity;
  String _imageUrl;
  double _rating;
  int _soldCount;

  ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String category,
    required int stockQuantity,
    required String imageUrl,
    double rating = 0.0,
    int soldCount = 0,
  })  : _id = id,
        _name = name,
        _description = description,
        _price = price,
        _category = category,
        _stockQuantity = stockQuantity,
        _imageUrl = imageUrl,
        _rating = rating,
        _soldCount = soldCount;

  // Getters
  String get id => _id;
  String get name => _name;
  String get description => _description;
  double get price => _price;
  String get category => _category;
  int get stockQuantity => _stockQuantity;
  String get imageUrl => _imageUrl;
  double get rating => _rating;
  int get soldCount => _soldCount;

  // Setters
  set id(String value) => _id = value;
  set name(String value) => _name = value;
  set description(String value) => _description = value;
  set price(double value) => _price = value;
  set category(String value) => _category = value;
  set stockQuantity(int value) => _stockQuantity = value;
  set imageUrl(String value) => _imageUrl = value;
  set rating(double value) => _rating = value;
  set soldCount(int value) => _soldCount = value;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
      rating: json['rating']?.toDouble() ?? 0.0,
      soldCount: json['soldCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'description': _description,
      'price': _price,
      'category': _category,
      'stockQuantity': _stockQuantity,
      'imageUrl': _imageUrl,
      'rating': _rating,
      'soldCount': _soldCount,
    };
  }
}
