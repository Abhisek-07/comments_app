import 'dart:developer';

import 'package:comments_app/states/auth_state.dart';
import 'package:comments_app/ui/widgets/formfield_widget.dart';
import 'package:comments_app/utils/app_colors.dart';
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
  final TextEditingController _userNameController = TextEditingController();

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

  String? _validateUserName(String? value) {
    if (isSignUp) {
      if (value == null || value.isEmpty) {
        return "Please enter your user name";
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
          _emailController.text,
          _passwordController.text,
          _userNameController.text,
        );
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
      _userNameController.clear();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: MediaQuery.of(context).viewInsets +
            const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appBlue,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isSignUp ? 'Signup' : 'Login',
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            // Toggle between Sign In and Sign Up
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isSignUp ? "Already have an account?" : "New here?",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: _toggleFormType,
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isSignUp ? "Login" : "Signup",
                    style: const TextStyle(
                      color: AppColors.appBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      )),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Comments',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appBlue),
              ),
              Expanded(
                child: Center(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // user name field
                        if (isSignUp) ...[
                          FormfieldWidget(
                            labelText: "Name",
                            controller: _userNameController,
                            validator: _validateUserName,
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Email input
                        FormfieldWidget(
                          labelText: "Email",
                          controller: _emailController,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),
                        // Password input
                        FormfieldWidget(
                          labelText: "Password",
                          validator: _validatePassword,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        // Sign In / Sign Up Button
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
