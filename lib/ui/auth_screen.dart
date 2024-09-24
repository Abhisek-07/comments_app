import 'dart:developer';

import 'package:comments_app/states/auth_state.dart';
import 'package:comments_app/utils/app_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isSignUp = false;

  AuthState get authProvider => ref.watch(authStateProvider.notifier);

  // Validation logic
  String? _validateEmail(String? value) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (isSignUp) {
      if (value != _passwordController.text) {
        return 'Passwords do not match';
      } else if (value == null || value.isEmpty) {
        return "Please confirm your password";
      }
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.loaderOverlay.show();
      if (isSignUp) {
        log("Signing up...");
        // Handle sign up logic
        // Use FirebaseAuthService for Sign Up
        User? user = await authProvider.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
        context.loaderOverlay.hide();
        if (user != null) {
          log("User signed up successfully");
          AppHelper.showAlert(
              message: "User signed up successfully.",
              alertType: AlertType.success);
          // Navigate to another screen if needed
        }
      } else {
        log("Signing in...");
        // Handle sign in logic
        // Use FirebaseAuthService for Sign In
        User? user = await authProvider.signInWithEmailPassword(
            _emailController.text, _passwordController.text);
        context.loaderOverlay.hide();
        if (user != null) {
          log("User signed in successfully");
          AppHelper.showAlert(
              message: "User signed in successfully.",
              alertType: AlertType.success);
          // Navigate to another screen if needed
        }
      }
    } else {
      // _updateUI();
      // _formKey.currentState!.reset();
    }
  }

  void _toggleFormType() {
    setState(() {
      isSignUp = !isSignUp;
      _formKey.currentState!.reset();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Space at the top
                // Illustration image
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Image.asset(
                //     'assets/illustrations/user_illustration.webp', // Replace with your own illustration
                //     height: 150,
                //   ),
                // ),
                const SizedBox(height: 20),
                // Title for the app (replace with your app name)
                Text(
                  isSignUp ? 'Create Account' : 'Welcome Back',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Email input
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailController,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password input
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validatePassword,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Confirm Password (only for Sign Up)
                if (isSignUp)
                  TextFormField(
                    controller: _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validateConfirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                // Sign In / Sign Up Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isSignUp ? 'Create Account' : 'Sign In',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                // Toggle between Sign In and Sign Up
                TextButton(
                  onPressed: _toggleFormType,
                  child: Text(
                    isSignUp
                        ? "Already have an account? Sign In"
                        : "No account? Register",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
