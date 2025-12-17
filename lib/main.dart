import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:habitai/screens/auth/login_screen.dart';
import 'package:habitai/services/auth_service.dart';
import 'package:habitai/services/firestore_service.dart';
import 'package:habitai/Habits/habit_tracker.dart';
// import 'package:habitai/Habits/habit_tracker_binding.dart';
import 'package:habitai/welcome.dart';
import './theme.dart';
import 'package:timezone/data/latest.dart' as tz;

// Firebase option imports
import 'Habits/habit_controller.dart';
import 'firebase_options_dev.dart';
import 'firebase_options_staging.dart';
import 'firebase_options_prod.dart';
import 'package:habitai/services/notification_service.dart';
import 'package:habitai/services/push_service.dart';
import 'package:habitai/services/revenue_cat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // 1️⃣ Determine flavor
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 2️⃣ Load environment variables
  try {
    await dotenv.load(fileName: "assets/.env.$env");
    print('✅ .env file loaded for $env');
  } catch (e) {
    print('⚠️ Failed to load .env file for $env: $e');
  }

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

  // 4️⃣ Initialize Firebase safely
  try {
    await Firebase.initializeApp(options: firebaseOptions);
    print('✅ Firebase initialized successfully');

    // Enable Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    print('✅ Firestore offline persistence enabled');
  } catch (e, st) {
    print('❌ Firebase initialization failed: $e');
    print(st);
  }
  // ✅ 5️⃣ Register controllers AFTER Firebase is ready
  Get.put(HabitTrackerController(), permanent: true);
  Get.put(RevenueCatService(), permanent: true);
  
  print('✅ Badge system initialized with habit controller');

  print('✅ Controllers registered');

  // 6️⃣ Initialize Crashlytics safely
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      FlutterError.dumpErrorToConsole(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    print('✅ Crashlytics initialized');
  } catch (e) {
    print('⚠️ Crashlytics failed to initialize: $e');
  }

  // 7️⃣ Analytics safe init
  try {
    await FirebaseAnalytics.instance.logEvent(
      name: 'app_start',
      parameters: {'env': env},
    );
    print('📊 Firebase Analytics event logged');
  } catch (e) {
    print('⚠️ Analytics initialization failed: $e');
  }

  print('🔹 Running flavor: $env');
  print('🔹 API URL: ${dotenv.env['API_BASE_URL']}');
  // 8️⃣ Run app
  // Initialize notification & push services so background handlers are registered before UI runs.
  bool notifyExactDenied = false;
  bool notifySchedulingFailed = false;
  try {
    await NotificationService().init();
    await PushService().init();
    print('✅ Notification & Push services initialized');

// ⬇️ Request Android & iOS notification permission
    final granted = await NotificationService().requestPermissions();
    print('📍 Notification permission granted: $granted');
    // Determine flags to show (but DO NOT call Get.snackbar here — Get isn't ready)
    notifyExactDenied = await NotificationService().isExactAlarmDenied();
    notifySchedulingFailed = await NotificationService().hasSchedulingFailed();
  } catch (e, st) {
    print('⚠ Notifications init failed: $e\n$st');
  }
// quick test: immediate local notification
  runApp(HabitAIApp(
    showExactDeniedHint: notifyExactDenied,
    showSchedulingFailedHint: notifySchedulingFailed,
  ));
}
/// Root App Widget
class HabitAIApp extends StatelessWidget {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  final bool showExactDeniedHint;
  final bool showSchedulingFailedHint;

  HabitAIApp({super.key, this.showExactDeniedHint = false, this.showSchedulingFailedHint = false});

  Future<Widget> _getInitialScreen() async {
    final user = _auth.currentUser;
    if (user == null) return const LoginScreen();
    try {
      final completed = await _firestore.hasCompletedOnboarding();
      if (completed) {
        return HabitTrackerScreen(); // main app screen
      } else {
        return const WelcomeScreen();
      }
    } catch (e) {
      print('⚠️ Firestore onboarding check failed: $e');
      return const LoginScreen(); // fallback to safe route
    }
  }
  @override
  Widget build(BuildContext context) {
    // After the first frame, surface any persisted notification scheduling warnings via Get.snackbar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showExactDeniedHint) {
        try {
          Get.snackbar(
            'Notifications may be unreliable',
            'Exact alarms are not permitted on this device. Scheduled reminders may not fire at exact times. To enable exact alarms add SCHEDULE_EXACT_ALARM to your AndroidManifest and allow Exact Alarms in system settings (Android 12+).',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade900,
            colorText: Colors.white,
            duration: const Duration(seconds: 8),
          );
        } catch (_) {}
      }
      if (showSchedulingFailedHint) {
        try {
          Get.snackbar(
            'Reminder scheduling failed',
            'Previously the app could not register scheduled reminders on this device. Test on a real device or enable exact alarms in system settings.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade900,
            colorText: Colors.white,
            duration: const Duration(seconds: 8),
          );
        } catch (_) {}
      }
    });
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return FutureBuilder<Widget>(
          future: _getInitialScreen(),
          builder: (context, snap) {
            // while deciding initial screen
            if (snap.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                home: Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            }
            return GetMaterialApp(
              title: 'HabitAI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              home: snap.data ??
                  (user == null
                      ? const LoginScreen()
                      : const WelcomeScreen()),
              getPages: [
                GetPage(
                  name: '/habit_tracker',
                  page: () => HabitTrackerScreen(),
                  binding: HabitTrackerBinding(),
                ),
                GetPage(name: '/welcome', page: () => WelcomeScreen()),
                GetPage(name: '/login', page: () => LoginScreen()),
              ],
            );
          },
        );
      },
    );
  }
}
/// Placeholder Home Screen (Crashlytics test)
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
            FirebaseCrashlytics.instance.crash();
          },
          child: const Text('Test Crashlytics (crash app)'),
        ),
      ),
    );
  }
}
