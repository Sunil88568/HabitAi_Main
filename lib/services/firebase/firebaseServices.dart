import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:logger/logger.dart';

import '../storage/preferences.dart';
import 'firebase_options.dart';



class FirebaseServices{
  // static final _chatCtrl = ChatCtrl.find;
  static String? fcmToken;
  static late DatabaseReference _database;

  static late FirebaseMessaging _messaging;
  static late BuildContext _context;
  static Future<void> init(context) async{
    _context = context;
    // runZonedGuarded<Future<void>>(() async {
    //   WidgetsFlutterBinding.ensureInitialized();
    //   await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform,
    //   );
    //
    //   FlutterError.onError =
    //       FirebaseCrashlytics.instance.recordFlutterFatalError;
    // }, (error, stack) =>
    //     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));

    WidgetsFlutterBinding.ensureInitialized();
    if(Platform.isIOS){
      if(Firebase.apps.isEmpty){
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    }else{
      await Firebase.initializeApp();
    }


    _messaging = FirebaseMessaging.instance;
    _database = FirebaseDatabase.instance.ref();

    requestGetToken();
     // await FirebaseMessaging.instance.setAutoInitEnabled(true);
    return;
  }

  static Future requestGetToken() async{
    await _requestPermissions().then((value) {
    });
   await _generateDeviceToken();
   return ;
  }



  static listener() async{
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    _notificationListeners();
  }

  static Future _generateDeviceToken() async{
    if(Platform.isIOS){
     final gggg = await _messaging.getAPNSToken();
     print(gggg);
      // getAPNSToken
    }
    await _messaging.deleteToken();
    try{
      // if(await _requestPermissions()){

       await _messaging.getToken().then((value) {
          fcmToken = value;
          // Preferences.setFcmToken = fcmToken;
          print('token result ....... +$value');
        });

        //    .onError((error,trace){
        //   print('token result ....... +$error');
        // }).catchError((onError){
        //   print('token result ....... +$onError');
        // });
      // }
    }catch(e){
      print('token result ....... +exception:: $e');
    }

    return ;

    // if(await _requestPermissions()){
    //   _messaging.getToken().then((value) {
    //     fcmToken = value;
    //     print('token result ....... +$value');
    //   });
    // }
  }

  static _notificationListeners(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{

      Map<String,dynamic> notification = message.data;
      RemoteNotification? notification1 = message.notification;

      Logger().d(message.data);
      Logger().d(message.notification?.toMap());
      Logger().d(message.toMap());

      final data = {
        "senderId": "664cae8f50f10f5db469631f",
        "senderType": "user",
        "recipientId": "664b66a3f4997da688aa4e88",
        "isDeleted": false,
        "type": "text",
        "message": message.notification?.body ?? '' + message.sentTime!.toIso8601String(),
        "threadId": "664b66a3f4997da688aa4e88664cae8f50f10f5db469631f",
        "_id": "667cfe227761ecc7aee422e3",
        "timestamp": "2024-06-27T05:52:34.238Z",
        "__v": 0
      };

      // final msg = ChatItemDataModel.fromJsonGetSingleChat(data);
      // _chatCtrl.getMessageListener(msg);



      // {
      //   "senderId": null,
      //   "category": null,
      //   "collapseKey": "com.app.kioski",
      //   "contentAvailable": false,
      //   "data": {
      //     "payload": "{\"name\":\"buyer\",\"email\":\"bhd@gmail.com\",\"image\":\"Abcd.jpg\",\"mobileNumber\":\"+911212121212\"}",
      //     "body": "Peter parker!!",
      //     "type": "Chat messages",
      //     "title": "buyer Sends you a message"
      //   },
      //   "from": "220349326802",
      //   "messageId": "0:1720419729653704%e989679ae989679a",
      //   "messageType": null,
      //   "mutableContent": false,
      //   "notification": {
      //     "title": "buyer Sends you a message",
      //     "titleLocArgs": [],
      //     "titleLocKey": null,
      //     "body": "Peter parker!!",
      //     "bodyLocArgs": [],
      //     "bodyLocKey": null,
      //     "android": {
      // W/FirebaseMessaging(13065): Unable to log event: analytics library is missing
      //       "channelId": null,
      //       "clickAction": null,
      //       "color": null,
      //       "count": null,
      //       "imageUrl": null,
      //       "link": null,
      //       "priority": 0,
      //       "smallIcon": null,
      //       "sound": null,
      //       "ticker": null,
      //       "tag": null,
      //       "visibility": 0
      //     },
      //     "apple": null,
      //     "web": null
      //   },
      //   "sentTime": 1720419729645,
      //   "threadId": null,
      //   "ttl": 2419200
      // }




      // Logger().d(message.notification?.body);

      if (message.notification != null) {
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
                icon:  '@mipmap/ic_launcher',
                // other properties...
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      Logger().d('notification .....onMessageOpenedApp');
      Logger().d(message.toMap());

    });
    FirebaseMessaging.onBackgroundMessage((message) async{
      await Firebase.initializeApp();
      Logger().d('notification .....onBackgroundMessage');
      Logger().d(message.toMap());

      // {
      //   "senderId": null,
      //   "category": null,
      //   "collapseKey": "com.app.kioski",
      //   "contentAvailable": false,
      //   "data": {
      //     "payload": "{\"name\":\"buyer\",\"email\":\"bhd@gmail.com\",\"image\":\"Abcd.jpg\",\"mobileNumber\":\"+911212121212\"}",
      //     "body": "Peter parker!!",
      //     "type": "Chat messages",
      //     "title": "buyer Sends you a message"
      //   },
      //   "from": "220349326802",
      //   "messageId": "0:1720419631315518%e989679ae989679a",
      //   "messageType": null,
      //   "mutableContent": false,
      //   "notification": {
      //     "title": "buyer Sends you a message",
      //     "titleLocArgs": [],
      //     "titleLocKey": null,
      //     "body": "Peter parker!!",
      //     "bodyLocArgs": [],
      //     "bodyLocKey": null,
      //     "android": {
      //       "channelId": null,
      //       "clickAction": null,
      //       "color": null,
      //       "count": null,
      //       "imageUrl": null,
      //       "link": null,
      //       "priority": 0,
      //       "smallIcon": null,
      //       "sound": null,
      //       "ticker": null,
      //       "tag": null,
      //       "visibility": 0
      //     },
      //     "apple": null,
      //     "web": null
      //   },
      //   "sentTime": 1720419631307,
      //   "threadId": null,
      //   "ttl": 2419200
      // }

    });
  }


  static  Future<bool> _requestPermissions() async{
    try{
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
        print('User granted permission');
        if (Platform.isAndroid) {
          await FirebaseMessaging.instance.setAutoInitEnabled(true);
        }
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
        return false;
      } else {
        print('User declined or has not accepted permission');
        return false;
      }
    }catch(e){
      return false;
    }

  }

  static Future<void> saveUserToRealtimeDB({
    required String userId,
    required String name,
    required String email,
    String? image,
    String? gender,
    String? dob,
    String? mobileNumber,
    String? countryCode,
  }) async {
    try {
      await _database.child('users').child(userId).set({
        'name': name,
        'email': email,
        'image': image,
        'gender': gender,
        'dob': dob,
        'mobileNumber': mobileNumber,
        'countryCode': countryCode,
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      });
    } catch (e) {
      print('Error saving user to Realtime DB: $e');
    }
  }
}


final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
);
