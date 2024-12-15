import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'package:scratch_ecommerce/screens/auth/login_screen.dart';
import 'package:scratch_ecommerce/screens/admin/admin_dashboard.dart';
import 'package:scratch_ecommerce/screens/profile/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    if (user == null) {
      // Redirect to login screen
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      return const SizedBox(); // Prevent build rendering
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          ProfileMenuItem(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            onTap: () {
              // Navigate to orders screen
            },
          ),
          if (user.isAdmin)
            ProfileMenuItem(
              icon: Icons.admin_panel_settings,
              title: 'Admin Dashboard',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboard(),
                  ),
                );
              },
            ),
          ProfileMenuItem(
            icon: Icons.location_on,
            title: 'Delivery Addresses',
            onTap: () {
              // Navigate to addresses screen
            },
          ),
          ProfileMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // Navigate to settings screen
            },
          ),
          ProfileMenuItem(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help screen
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
            ),
            child: const Text('Sign Out',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
