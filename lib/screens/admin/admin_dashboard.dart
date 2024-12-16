import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:scratch_ecommerce/screens/admin/analytics_card.dart';
import 'package:scratch_ecommerce/screens/admin/category_management.dart';
import 'package:scratch_ecommerce/screens/admin/order_management.dart';
import 'package:scratch_ecommerce/screens/admin/product_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalOrders = 0;
  double totalSales = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<dynamic> _orders = [];
  Map<String, double> productSales =
      {}; // To store product names and their sales.

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch order data
    _fetchProductSales(); // Fetch product sales data
  }

  Future<void> _fetchOrders() async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _orders.clear();
          totalSales = 0;

          for (var order in snapshot.docs) {
            _orders.add(order);
            final totalPrice = order['totalPrice'] ?? 0.0;
            totalSales += totalPrice;
          }
          totalOrders = _orders.length;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting orders: $e')),
      );
    }
  }

  Future<void> _fetchProductSales() async {
    try {
      final snapshot = await _firestore.collection('product').get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          productSales.clear();
          for (var product in snapshot.docs) {
            final productName = product['name'] ?? 'Unnamed';
            final sales = product['sales']?.toDouble() ?? 0.0;
            productSales[productName] = sales;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting product sales: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Orders'),
              Tab(text: 'Products'),
              Tab(text: 'Categories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            const OrderManagement(),
            const ProductManagement(),
            const CategoryManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnalyticsCard(
                  title: 'Total Sales',
                  value: '\$${totalSales.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnalyticsCard(
                  title: 'Orders',
                  value: '$totalOrders',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Sales Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSalesChart(),
        ],
      ),
    );
  }

  Widget _buildSalesChart() {
    if (productSales.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 300, // Height of the chart
      child: PieChart(
        PieChartData(
          sections: productSales.entries.map((entry) {
            return PieChartSectionData(
              title: '${entry.key}\n${entry.value.toStringAsFixed(0)}',
              value: entry.value,
              radius: 80,
              color: _getRandomColor(entry.key),
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Color _getRandomColor(String key) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.yellow,
      Colors.cyan,
    ];
    return colors[key.hashCode % colors.length];
  }
}
