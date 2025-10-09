import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options_dev.dart';
import 'firebase_options_staging.dart';
import 'firebase_options_prod.dart';

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

  runApp(const HabitAIApp());
}

/// Root App Widget
class HabitAIApp extends StatelessWidget {
  const HabitAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitAI',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
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
