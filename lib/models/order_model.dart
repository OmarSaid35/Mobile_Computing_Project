class Order {
  final String id;
  final String username;
  final double totalPrice;
  final DateTime time;

  Order({
    required this.id,
    required this.username,
    required this.totalPrice,
    required this.time,
  });

  // Factory method to create a Category from Firestore data
  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      username: data['username'] as String,
      totalPrice: data['totalPrice'] as double,
      time: data['time'] as DateTime,
    );
  }
}
