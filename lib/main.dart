import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'package:scratch_ecommerce/providers/cart_provider.dart';
import 'package:scratch_ecommerce/screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scratch_ecommerce/screens/auth/login_screen.dart';
import 'package:scratch_ecommerce/screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Test Firestore connection
  FirebaseFirestore.instance
      .collection('test')
      .doc('testDoc')
      .set({'testField': 'testValue'})
      .then((value) => print('Document successfully written!'))
      .catchError((error) => print('Failed to write document: $error'));

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
             final authProvider =  AuthProvider();
             authProvider.autoLogin();
             return authProvider;
          }
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'E-commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
          home:  Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.user == null) {
                return const LoginScreen();
            } else if (authProvider.user!.isAdmin == true) {
                return const AdminDashboard();
            } else {
                return const HomeScreen();
            }
          }
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}