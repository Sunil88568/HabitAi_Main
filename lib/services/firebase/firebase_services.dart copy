import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:question_app/utils/appUtils.dart';

import '../storage/preferences.dart';
import 'firebase_options.dart';

class FirebaseServices {
  // static final _chatCtrl = ChatCtrl.find;
  static String? fcmToken;

  static RemoteMessage? _currentRemoteMessage;

  static late FirebaseMessaging _messaging;
  static late BuildContext _context;

  static Future<void> init(context) async {
    _context = context;

    var status = await Permission.notification.status;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification
    ].request();

    if (!status.isGranted) {
      await Permission.notification.request();
    }


    // await _checkAndRequestPermission(Permission.notification);
    // await _checkAndRequestPermission(Permission.storage);
    // await _checkAndRequestPermission(Permission.camera);
    // await _checkAndRequestPermission(Permission.location);

    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (e) {
      AppUtils.log('here is firebase issuee.... $e');
    }
    return;
  }

  static Future<void> _checkAndRequestPermission(Permission permission) async {
    var status = await permission.status;

    // Keep asking if the user denies (but hasn't permanently denied)
    while (status.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        AppUtils.log('$permission granted');
        return;
      }
      status = result;
    }

    if (status.isPermanentlyDenied) {
      AppUtils.log('$permission permanently denied. Opening settings...');
      await openAppSettings();
    }
  }

  static listener() async {
    if (!Platform.isAndroid) {
      return;
    }
    _messaging = FirebaseMessaging.instance;
    _generateDeviceToken();
    _requestPermissions().then((value) {});
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _notificationListeners();
  }



  static _generateDeviceToken() async {
    try {
      _messaging.getToken().then((value) {
        fcmToken = value;
        Preferences.fcmToken = fcmToken;
        AppUtils.log('token result ....... +${Preferences.fcmToken}');
      });
    } catch (e) {
      AppUtils.log('token result ....... +exception:: $e');
    }
  }

  static initialMessageCall(RemoteMessage remoteMessage){
    _handleNotificationClick(remoteMessage,isInitialMessage : true);
  }

  static _notificationListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _currentRemoteMessage = message;

      final data = message.data;
      final payload = data['data'];

      Logger().d(message.toMap());

      AppUtils.log(message.notification?.toMap());

      if (message.data != null) {
        _flutterLocalNotificationsPlugin.show(
            1,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                // icon: android?.smallIcon,
                icon: '@mipmap/ic_launcher',
                // other properties...
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      _handleNotificationClick(message);

      AppUtils.log('onMessageOpenedApp');

      // Logger().d('notification .....onMessageOpenedApp');
      // Logger().d(message.toMap());
      // AppUtils.log(message.data);
      // AppUtils.log(message.notification?.toMap());
      //
      // ChatController.find.fireRecentChatEvent();
      // // ChatController.find.joinRecentChat();
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      _handleNotificationClick(message);
      await Firebase.initializeApp();
    });

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (data) {
          if (_currentRemoteMessage != null) {
            _handleNotificationClick(_currentRemoteMessage!);
            _currentRemoteMessage = null;
          }
        });
  }


  static Future<bool> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      sound: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppUtils.log('User granted permission');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      AppUtils.log('User granted provisional permission');
      return false;
    } else {
      AppUtils.log('User declined or has not accepted permission');
      return false;
    }
  }

  static void _handleNotificationClick(RemoteMessage message,
      {bool isInitialMessage = false}) {
    // AppUtils.log('regrefergregregregregergre');

    final data = message.data;

    // AppUtils.log(data['messageType']);


    // I/flutter ( 7383): │ 🐛 {
    // I/flutter ( 7383): │ 🐛   "senderId": "6800c66b03253d2775b3a875",
    // I/flutter ( 7383): │ 🐛   "chatId": "680213c4d145545c66380cc5",
    // I/flutter ( 7383): │ 🐛   "messageType": "chat"
    // I/flutter ( 7383): │ 🐛 }
  }
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);


