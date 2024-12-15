import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'package:scratch_ecommerce/screens/cart/cart_screen.dart';
import 'package:scratch_ecommerce/screens/categories/categories_screen.dart';
import 'package:scratch_ecommerce/screens/profile/profile_screen.dart';
import 'package:scratch_ecommerce/screens/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens with retained states
  final List<Widget> _screens = [
    const CategoriesScreen(),
    const SearchScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Dynamically change AppBar title based on selected tab
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Categories';
      case 1:
        return 'Search';
      case 2:
        return 'Your Cart';
      case 3:
        return 'Profile';
      default:
        return 'E-commerce App';
    }
  }
}
