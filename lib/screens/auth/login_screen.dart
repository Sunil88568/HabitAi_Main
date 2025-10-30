import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'signup_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await _auth.signInWithEmail(
          _emailController.text, _passwordController.text);

      // Check if onboarding is completed
      final firestore = FirestoreService();
      final completed = await firestore.hasCompletedOnboarding();

      if (completed) {
        Get.offAllNamed('/habit_tracker'); // Already completed
      } else {
        Get.offAllNamed('/welcome'); // Show WelcomeScreen
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in to continue your journey",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF2A2A3A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF2A2A3A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),

                // Email Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Login",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 20),

                // Google Sign-In
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    setState(() => _loading = true);
                    try {
                      await _auth.signInWithGoogle();
                      final firestore = FirestoreService();
                      final completed = await firestore.hasCompletedOnboarding();
                      if (completed) {
                        Get.offAllNamed('/habit_tracker');
                      } else {
                        Get.offAllNamed('/welcome');
                      }
                    } catch (e) {
                      setState(() => _error = e.toString());
                    } finally {
                      setState(() => _loading = false);
                    }
                  },
                ),

                // Apple Sign-In
                SignInButton(
                  Buttons.Apple,
                  onPressed: () async {
                    setState(() => _loading = true);
                    try {
                      await _auth.signInWithApple();
                      final firestore = FirestoreService();
                      final completed = await firestore.hasCompletedOnboarding();
                      if (completed) {
                        Get.offAllNamed('/habit_tracker');
                      } else {
                        Get.offAllNamed('/welcome');
                      }
                    } catch (e) {
                      setState(() => _error = e.toString());
                    } finally {
                      setState(() => _loading = false);
                    }
                  },
                ),

                const SizedBox(height: 16),
                // Anonymous Guest
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() => _loading = true);
                      try {
                        await _auth.signInAnonymously();
                        final firestore = FirestoreService();
                        final completed = await firestore.hasCompletedOnboarding();
                        if (completed) {
                          Get.offAllNamed('/habit_tracker');
                        } else {
                          Get.offAllNamed('/welcome');
                        }
                      } catch (e) {
                        setState(() => _error = e.toString());
                      } finally {
                        setState(() => _loading = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Continue as Guest"),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
