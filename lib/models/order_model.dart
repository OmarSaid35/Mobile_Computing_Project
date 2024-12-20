class Order {
  final String id;
  final String username;
  final double totalPrice;
  final DateTime time;
  final String feedback; // New field

  Order({
    required this.id,
    required this.username,
    required this.totalPrice,
    required this.time,
    required this.feedback, // Initialize feedback
  });

  factory Order.fromFirestore(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      username: data['username'] as String,
      totalPrice: data['totalPrice'] as double,
      time: data['time'] as DateTime,
      feedback: data['feedback'] ?? '', // Default empty string if no feedback
    );
  }
}
