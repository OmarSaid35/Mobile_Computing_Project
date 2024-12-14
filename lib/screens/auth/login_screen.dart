import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scratch_ecommerce/providers/auth_provider.dart';
import 'signup_screen.dart';
import 'package:scratch_ecommerce/screens/admin/admin_dashboard.dart';
import 'package:scratch_ecommerce/screens/home_screen.dart';
import 'package:scratch_ecommerce/screens/auth/forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe =
      false; // Variable to track the "Remember Me" checkbox state

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.autoLogin(); // Attempt to auto-login the user

    // After autoLogin, check if the user is signed in
    final user = authProvider.user;
    if (user != null) {
      // Navigate to the appropriate screen based on the user's role
      if (user.isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Remember Me'),
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text('Create an account'),
              ),
              // In LoginScreen, add a button for forget password
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordScreen(),
                    ),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await Provider.of<AuthProvider>(context, listen: false).signIn(
          email: _emailController.text,
          password: _passwordController.text,
          rememberMe: _rememberMe, // Pass the rememberMe value
        );

        // Check if the user is an admin
        final user = Provider.of<AuthProvider>(context, listen: false).user;
        if (user != null && user.isAdmin) {
          // Navigate to Admin Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        } else {
          // Navigate to regular user home screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
