import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import 'signup_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../../theme/app_theme.dart';


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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "Sign in to continue your journey",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkError : AppColors.lightError)),
                ],
                const SizedBox(height: 24),

                // Email Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
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
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                      ),
                    ),
                    Expanded(child: Divider(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder)),
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
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onBackground,
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