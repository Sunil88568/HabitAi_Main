// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';
// import '../../feature/presentation/screens/home/water_bottle.dart';
// import '../../feature/presentation/screens/splash.dart';
// import '../../main.dart';
// import '../../utils/app_utils.dart';
// import 'firebase_options.dart';
//
// class FirebaseServices {
//   static String? fcmToken;
//   static late FirebaseMessaging _messaging;
//
//   static _analytics(Function() callBack) {
//     callBack();
//     // runZonedGuarded<Future<void>>(() async {
//     //   WidgetsFlutterBinding.ensureInitialized();
//     //   callBack();
//     //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
//     // }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
//   }
//
//   static Future<void> init(context) async {
//     _analytics(() async {
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//       _messaging = FirebaseMessaging.instance;
//
//
//       checkInitialMessage();
//     });
//   }
//
//   static void checkInitialMessage() async {
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       Logger().d("App launched from a notification: ${initialMessage.toMap()}");
//       _handleNotificationNavigation(initialMessage);
//     }
//   }
//
//
//   static void _handleNotificationNavigation(RemoteMessage message) {
//     if (navState.currentState != null) {
//       navState.currentState?.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const Splash()),
//             (route) => false,
//       );
//     } else {
//       Logger().e("Navigator state is null, cannot push route");
//     }
//   }
//
//
//
//   static Future<String?> requestGetToken() async {
//     try {
//       await _requestPermissions();
//       await _generateDeviceToken();
//       return fcmToken;
//     } catch (e) {
//       AppUtils.log("Error while getting token: $e");
//       return null;
//     }
//   }
//
//   static listener() async {
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     _notificationListeners();
//   }
//
//   static Future _generateDeviceToken() async {
//     if (Platform.isIOS) {
//       final apnsToken = await _messaging.getAPNSToken();
//       print(apnsToken);
//     }
//     await _messaging.deleteToken();
//     try {
//       await _messaging.getToken().then((value) {
//         fcmToken = value;
//         if (kDebugMode) {
//           print('FCM Token: $value');
//         }
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error getting token: $e');
//       }
//     }
//   }
//
//   static _notificationListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       Logger().d("Foreground message received: ${message.toMap()}");
//
//       if (message.notification != null) {
//         _flutterLocalNotificationsPlugin.show(
//           1,
//           message.notification?.title,
//           message.notification?.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               _channel.id,
//               _channel.name,
//               channelDescription: _channel.description,
//               icon: '@mipmap/ic_launcher',
//               importance: Importance.high,
//               priority: Priority.high,
//               playSound: true,
//               enableVibration: true,
//               ongoing: false,
//               autoCancel: true,
//               fullScreenIntent: false,
//               visibility: NotificationVisibility.public,
//             ),
//             iOS: DarwinNotificationDetails(
//               presentAlert: true,
//               presentBadge: true,
//               presentSound: true,
//               interruptionLevel: InterruptionLevel.critical,
//             ),
//           ),
//         );
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) async {
//       Logger().d("Notification clicked when app in background: ${message.toMap()}");
//       _handleNotificationNavigation(message);
//     });
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
//
//
//
//
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     Logger().d('Background notification received: ${message.toMap()}');
//   }
//
//   static Future<bool> _requestPermissions() async {
//     try {
//       NotificationSettings settings = await _messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: true,
//         sound: true,
//         provisional: false,
//       );
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         if (kDebugMode) {
//           print('User granted permission');
//         }
//         if (Platform.isAndroid) {
//           await FirebaseMessaging.instance.setAutoInitEnabled(true);
//         }
//         return true;
//       } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//         if (kDebugMode) {
//           print('User granted provisional permission');
//         }
//         return false;
//       } else {
//         if (kDebugMode) {
//           print('User declined permission');
//         }
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }
// }
//
// final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// const AndroidNotificationChannel _channel = AndroidNotificationChannel(
//   'high_importance_channel',
//   'High Importance Notifications',
//   description: 'This channel is used for important notifications.',
//   importance: Importance.high,
//   playSound: true,
// );