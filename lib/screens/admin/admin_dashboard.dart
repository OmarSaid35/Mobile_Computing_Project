import 'package:flutter/material.dart';
import 'package:scratch_ecommerce/screens/admin/analytics_card.dart';
import 'package:scratch_ecommerce/screens/admin/category_management.dart';
import 'package:scratch_ecommerce/screens/admin/order_management.dart';
import 'package:scratch_ecommerce/screens/admin/product_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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
              Tab(text: 'Products'),
              Tab(text: 'Orders'),
              Tab(text: "Categories",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            const ProductManagement(),
            const OrderManagement(),
            const CategoryManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnalyticsCard(
                  title: 'Total Sales',
                  value: '\$12,345',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AnalyticsCard(
                  title: 'Orders',
                  value: '123',
                  icon: Icons.shopping_cart,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Sales Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ]
      ),
    );
  }
}