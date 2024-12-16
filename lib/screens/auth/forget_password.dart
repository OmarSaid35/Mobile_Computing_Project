import 'package:flutter/material.dart'; // For the UI components (e.g., Scaffold, TextFormField, etc.)
//import 'package:provider/provider.dart'; // For state management with Provider
//import 'package:scratch_ecommerce/providers/auth_provider.dart'; // Your custom AuthProvider for handling authentication
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth for managing password reset
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scratch_ecommerce/models/user_model.dart'; // Assuming UserModel is imported

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forget Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _schoolNameController,
              decoration: const InputDecoration(
                  labelText: 'Enter your old school name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmNewPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: const Text('Reset Password'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Fetch user from Firestore using email
      final userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Get user data
        final userDoc = userQuery.docs.first;
        final user = UserModel.fromJson(userDoc.data());

        // Check if the school name matches
        if (user.schoolName == _schoolNameController.text) {
          // Send password reset email via Firebase Auth
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: _emailController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent!')),
          );
          Navigator.pop(context); // Go back to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('School name is incorrect')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user found with this email')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }
}
