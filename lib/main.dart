import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:habitai/screens/auth/login_screen.dart';
import 'package:habitai/services/auth_service.dart';
import 'package:habitai/services/firestore_service.dart';

import 'firebase_options_dev.dart';
import 'firebase_options_staging.dart';
import 'firebase_options_prod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habitai/Habits/habit_tracker.dart';
import 'package:habitai/Habits/habit_tracker_binding.dart'; // Added to fix error
import 'package:habitai/welcome.dart';
import "./theme.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Determine flavor
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 2️⃣ Load .env file for current flavor
  await dotenv.load(fileName: "assets/.env.$env");

  // 3️⃣ Choose Firebase config
  FirebaseOptions firebaseOptions;
  switch (env) {
    case 'staging':
      firebaseOptions = DefaultFirebaseOptionsStaging.currentPlatform;
      break;
    case 'prod':
      firebaseOptions = DefaultFirebaseOptionsProd.currentPlatform;
      break;
    default:
      firebaseOptions = DefaultFirebaseOptionsDev.currentPlatform;
  }

  // 4️⃣ Initialize Firebase
  await Firebase.initializeApp(options: firebaseOptions);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  print('🔹 Running flavor: $env');
  print('🔹 API URL: ${dotenv.env['API_BASE_URL']}');
  // 5️⃣ Initialize Crashlytics & handle uncaught errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    FlutterError.dumpErrorToConsole(errorDetails);
  };

  // Async/native errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 6️⃣ Log app start to Analytics
  await FirebaseAnalytics.instance.logEvent(name: 'app_start', parameters: {'env': env});

  runApp(HabitAIApp());
}

/// Root App Widget
class HabitAIApp extends StatelessWidget {
  final AuthService _auth = AuthService();

  final FirestoreService _firestore = FirestoreService();

  HabitAIApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final user = _auth.currentUser;
    if (user == null) return const LoginScreen();

    // Check if onboarding is completed
    final completed = await _firestore.hasCompletedOnboarding();
    if (completed) {
      return HabitTrackerScreen(); // or your main app screen
    } else {
      return const WelcomeScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return GetMaterialApp(
          title: 'HabitAI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: user == null ? const LoginScreen() : const WelcomeScreen(),
          getPages: [
            GetPage(name: '/habit_tracker', page: () => HabitTrackerScreen(), binding: HabitTrackerBinding()),
            GetPage(
              name: '/welcome',
              page: () => WelcomeScreen(),
            ),
            GetPage(
              name: '/login',
              page: () => LoginScreen(),
            ),
          ],
        );
      },
    );
  }
}


/// Placeholder Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitAI Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Crash test button
            FirebaseCrashlytics.instance.crash();
          },
          child: const Text('Test Crashlytics (crash app)'),
        ),
      ),
    );
  }
}
