import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options_dev.dart';
import 'firebase_options_staging.dart';
import 'firebase_options_prod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Determine flavor: dev, staging, prod
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 2️⃣ Load corresponding .env file
  await dotenv.load(fileName: ".env.$env");

  // 3️⃣ Initialize Firebase based on flavor
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

  await Firebase.initializeApp(options: firebaseOptions);

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
      body: const Center(
        child: Text(
          'Welcome to HabitAI!\nYour app is ready for M1 milestone.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
