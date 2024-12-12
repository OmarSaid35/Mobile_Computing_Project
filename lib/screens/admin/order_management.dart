import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class OrderManagement extends StatelessWidget {
  const OrderManagement({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder list of mock orders
    final mockOrders = [
      {'id': '1', 'status': 'Pending', 'total': 50.0},
      {'id': '2', 'status': 'Processing', 'total': 75.0},
      {'id': '3', 'status': 'Shipped', 'total': 120.0},
    ];

    return ListView.builder(
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        final order = mockOrders[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListTile(
            title: Text('Order #${order['id']}'),
            subtitle: Text(
              'Status: ${order['status']}\nTotal: \$${order['total']}',
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'processing',
                  child: Text('Mark as Processing'),
                ),
                const PopupMenuItem(
                  value: 'shipped',
                  child: Text('Mark as Shipped'),
                ),
                const PopupMenuItem(
                  value: 'delivered',
                  child: Text('Mark as Delivered'),
                ),
              ],
              onSelected: (value) {
                // Placeholder for updating order status
                print('Order #${order['id']} marked as $value');
              },
            ),
            onTap: () {
              // Placeholder for showing order details
              print('Show details for Order #${order['id']}');
            },
          ),
        );
      },
    );
  }
}
