import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<dynamic> _orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrders();
  }

  Future<void> _getOrders() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      if (snapshot.docs.isNotEmpty) {
        // Get all the order documents
        List<QueryDocumentSnapshot> orders = snapshot.docs;

        // Now you can work with the orders list
        for (QueryDocumentSnapshot order in orders) {
          _orders.add(order);
        }
      } else {
        print('No orders found.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("orders").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderData = _orders[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                title: Text('Username: ${orderData['username']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Time: ${orderData['time']}'),
                    Text(
                        'Price: \$${orderData['totalPrice'].toStringAsFixed(2)}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
