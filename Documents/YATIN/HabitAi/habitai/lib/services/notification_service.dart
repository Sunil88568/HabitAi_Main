import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../Habits/habit_controller.dart';

/// NotificationService singleton
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocal = FlutterLocalNotificationsPlugin();
  SharedPreferences? _prefs;

  static const String _scheduledKey = 'scheduled_reminders_v1';
  static const String _lastSentKeyPrefix = 'last_sent_';
  static const String _dailyEnabledKey = 'daily_reminders_enabled';
  static const String _exactDeniedKey = 'exact_alarms_denied_v1';
  static const String _schedulingFailedKey = 'scheduling_failed_v1';

  bool _channelsCreated = false;

  /// Sync scheduled reminders with the habit list.
  /// - Schedules reminders for habits with reminders == true.
  /// - Cancels reminders for disabled or deleted habits.
  /// Safe to call any time.
  Future<void> syncWithHabits(List<HabitItem> habitsList) async {
    _prefs ??= await SharedPreferences.getInstance();
    final scheduledMap = _getScheduledMap();
    final currentIds = habitsList.map((h) => h.id).toSet();

    // Remove reminders for deleted habits
    for (final sid in scheduledMap.keys.toList()) {
      if (!currentIds.contains(sid)) {
        try {
          await cancelHabitReminders(sid);
        } catch (e) {
          print('⚠ syncWithHabits cancel error for $sid: $e');
        }
      }
    }

    // Add or update reminders for current habits
    for (final h in habitsList) {
      try {
        final entry = scheduledMap[h.id];
        final storedTime = entry != null ? (entry['time'] as String?) : null;
        final wantedTime = '${h.reminderHour}:${h.reminderMinute}';
        final wantedDays = (h.daysOfWeek.isNotEmpty) ? h.daysOfWeek : null;

        if (h.reminders) {
          final needsReschedule = entry == null ||
              storedTime != wantedTime ||
              !_daysEqual(entry['daysOfWeek'] as List<dynamic>?, wantedDays);

          if (needsReschedule) {
            await cancelHabitReminders(h.id);
            final ok = await scheduleHabitReminder(
              h.id,
              h.reminderHour,
              h.reminderMinute,
              daysOfWeek: wantedDays,
            );
            if (!ok) {
              print('⚠ sync scheduling failed for habit ${h.id}');
            }
          }
        } else {
          // Habit reminders are disabled
          if (entry != null) {
            await cancelHabitReminders(h.id);
          }
        }
      } catch (e) {
        print('⚠ syncWithHabits error for habit ${h.id}: $e');
      }
    }
  }

  /// Compare two day-of-week lists robustly (prefs stores dynamic, code uses List<int>)
  /// Returns true when both are null/empty or contain the same integers regardless of order.
  bool _daysEqual(List<dynamic>? a, List<int>? b) {
    // treat null and empty the same
    final aList = (a ?? <dynamic>[])
        .map((e) {
          if (e is int) return e;
          if (e is String) return int.tryParse(e) ?? -999;
          if (e is num) return e.toInt();
          return -999;
        })
        .where((x) => x != -999)
        .toList();

    final bList = (b ?? <int>[]).map((e) => e).toList();

    if (aList.length != bList.length) return false;
    aList.sort();
    bList.sort();
    for (var i = 0; i < aList.length; i++) {
      if (aList[i] != bList[i]) return false;
    }
    return true;
  }

  /// Initialize local notifications (call after WidgetsFlutterBinding.ensureInitialized)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    // Initialize tz database
    tz_data.initializeTimeZones();

    // Get device timezone using flutter_timezone package
    // This reliably gets the IANA timezone name from the device
    String timezoneName;
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      timezoneName = timezoneInfo.identifier;
      print('📍 Device timezone from FlutterTimezone: $timezoneName');
    } catch (e) {
      print('⚠️ Failed to get timezone from FlutterTimezone: $e');
      timezoneName = 'UTC'; // Fallback to UTC
    }

    // Set the timezone for the notification scheduler
    try {
      tz.setLocalLocation(tz.getLocation(timezoneName));
      final offset = DateTime.now().timeZoneOffset;
      print(
          '📍 NotificationService: tz.local set to $timezoneName (offset: ${offset.inHours}h ${offset.inMinutes % 60}m)');
    } catch (e) {
      print('⚠️ Failed to set timezone $timezoneName, falling back to UTC: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    await _flutterLocal.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload ?? '';
        if (payload.isNotEmpty) handleSelectNotification(payload);
      },
    );
    // Create Android channels for scheduled & push conversions
    await _createAndroidChannels();
    // Ensure default consent flag exists
    _prefs!.setBool(_dailyEnabledKey, _prefs!.getBool(_dailyEnabledKey) ?? true);
    print('✅ NotificationService initialized');
  }

  Future<void> _createAndroidChannels() async {
    if (_channelsCreated) return;
    try {
      final androidImpl = _flutterLocal.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        const habitChannel = AndroidNotificationChannel(
          'habit_reminders',
          'Habit Reminders',
          description: 'Reminders for your habits',
          importance: Importance.high,
        );
        const pushChannel = AndroidNotificationChannel(
          'push_channel',
          'Push Notifications',
          description: 'Converted push notifications',
          importance: Importance.high,
        );

        await androidImpl.createNotificationChannel(habitChannel);
        await androidImpl.createNotificationChannel(pushChannel);
        _channelsCreated = true;
        print('✅ Android notification channels created');
      }
    } catch (e) {
      print('⚠ Failed to create Android channels: $e');
    }
  }

  /// Request notification permissions from the OS (returns true if granted or not required)
  Future<bool> requestPermissions() async {
    _prefs ??= await SharedPreferences.getInstance();

    try {
      if (Platform.isAndroid) {
        // Android 13+ requires POST_NOTIFICATIONS permission
        final messaging = FirebaseMessaging.instance;
        final settings = await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        final granted = settings.authorizationStatus == AuthorizationStatus.authorized;
        print("📍 Android POST_NOTIFICATIONS permission granted: $granted");
        return granted;
      }

      // iOS permission request
      final iosSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
      );

      final iosGranted = iosSettings.authorizationStatus == AuthorizationStatus.authorized ||
          iosSettings.authorizationStatus == AuthorizationStatus.provisional;

      print("📍 iOS notification permission granted: $iosGranted");
      return iosGranted;
    } catch (e) {
      print("⚠ Notification permission request error: $e");
      return false;
    }
  }

  Future<bool> getDailyRemindersEnabled() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getBool(_dailyEnabledKey) ?? true;
  }

  Future<void> setDailyRemindersEnabled(bool enabled) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(_dailyEnabledKey, enabled);
    if (!enabled) {
      // cancel all scheduled reminders persisted in map
      final map = _getScheduledMap();
      for (final habitId in map.keys.toList()) {
        await cancelHabitReminders(habitId);
      }
    }
  }

  int _habitReminderId(String habitId) => habitId.hashCode & 0x7FFFFFFF;

  /// Schedule a daily or weekly reminder for a habit.
  Future<bool> scheduleHabitReminder(String habitId, int hour, int minute,
      {List<int>? daysOfWeek, String? title, String? body}) async {
    await NotificationService().init();

    _prefs ??= await SharedPreferences.getInstance();
    final enabled = _prefs?.getBool(_dailyEnabledKey) ?? true;
    if (!enabled) {
      print('⛔ scheduleHabitReminder skipped because daily reminders disabled');
      return false;
    }

    // Ensure channels created (Android)
    await _createAndroidChannels();

    const androidDetails = AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Reminders for your habits',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true);
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    final payload = habitId;

    final baseId = _habitReminderId(habitId);

    bool anyScheduled = false;

    try {
      if (daysOfWeek != null && daysOfWeek.isNotEmpty) {
        for (final wd in daysOfWeek) {
          final subId = baseId + wd;
          final scheduled = _nextInstanceOfWeekdayTime(wd, hour, minute);
          final ok = await _safeZonedSchedule(
            id: subId,
            title: title ?? 'Habit Reminder',
            body: body ?? 'Time to work on your habit',
            scheduledDate: scheduled,
            details: details,
            payload: payload,
            match: DateTimeComponents.dayOfWeekAndTime,
          );
          if (ok) {
            anyScheduled = true;
            print('⏰ Scheduled habit $habitId (weekday $wd) at $scheduled id=$subId');
          } else {
            print('⚠ Scheduling failed for habit $habitId weekday $wd id=$subId');
          }
        }
      } else {
        final scheduled = _nextInstanceOfTime(hour, minute);
        final ok = await _safeZonedSchedule(
          id: baseId,
          title: title ?? 'Habit Reminder',
          body: body ?? 'Time to work on your habit',
          scheduledDate: scheduled,
          details: details,
          payload: payload,
          match: DateTimeComponents.time,
        );
        if (ok) {
          anyScheduled = true;
          final localTime = DateTime(scheduled.year, scheduled.month, scheduled.day, scheduled.hour, scheduled.minute);
          print('⏰ Scheduled habit $habitId daily at $hour:$minute');
          print('   📅 Local time: $localTime');
          print('   🌍 TZ time: $scheduled');
          print('   🆔 Notification ID: $baseId');
        } else {
          print('⚠ Scheduling failed for habit $habitId id=$baseId at $scheduled');
        }
      }

      // Persist marker only if scheduling succeeded
      if (anyScheduled) {
        final map = _getScheduledMap();
        map[habitId] = {
          'time': '$hour:$minute',
          'daysOfWeek': daysOfWeek,
        };
        await _prefs?.setString(_scheduledKey, jsonEncode(map));
        // Clear scheduling failure flag (if previously set)
        await _prefs?.remove(_schedulingFailedKey);
        return true;
      } else {
        // Record that scheduling failed so UI can inform the user
        await _prefs?.setBool(_schedulingFailedKey, true);
        return false;
      }
    } catch (e, st) {
      print('⚠ scheduleHabitReminder failed: $e\n$st');
      return false;
    }
  }

  Future<void> cancelHabitReminders(String habitId) async {
    _prefs ??= await SharedPreferences.getInstance();
    final baseId = _habitReminderId(habitId);
    final map = _getScheduledMap();
    final entry = map[habitId];
    try {
      if (entry != null && entry['daysOfWeek'] != null) {
        final List<dynamic> days = entry['daysOfWeek'];
        for (final wd in days) {
          final subId = baseId + (wd as int);
          await _flutterLocal.cancel(subId);
          print('🗑 Cancelled scheduled notification id=$subId for habit $habitId');
        }
      } else {
        await _flutterLocal.cancel(baseId);
        print('🗑 Cancelled scheduled notification id=$baseId for habit $habitId');
      }
    } catch (e) {
      print('⚠ cancelHabitReminders error: $e');
    }

    map.remove(habitId);
    await _prefs?.setString(_scheduledKey, jsonEncode(map));
  }

  Map<String, dynamic> _getScheduledMap() {
    final raw = _prefs?.getString(_scheduledKey);
    if (raw == null) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  // Show a notification but rate-limited per habitId
  Future<void> showRateLimitedNotification(String habitId, String title, String body,
      {int minIntervalSeconds = 60}) async {
    _prefs ??= await SharedPreferences.getInstance();
    final key = '$_lastSentKeyPrefix$habitId';
    final last = _prefs?.getInt(key) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - last < minIntervalSeconds * 1000) {
      print('🔕 Rate-limited notification for $habitId (last sent ${now - last}ms ago)');
      return;
    }
    await _prefs?.setInt(key, now);

    final id = _habitReminderId(habitId);
    const android = AndroidNotificationDetails('push_channel', 'Push',
        channelDescription: 'Push converted to local', importance: Importance.high);
    const details = NotificationDetails(android: android, iOS: DarwinNotificationDetails());
    await _flutterLocal.show(id, title, body, details, payload: habitId);
    print('🔔 Showed local notification for $habitId id=$id title="$title"');
  }

  /// Public deep-link handler when a notification is tapped
  void handleSelectNotification(String payload) {
    final habitId = payload;
    if (habitId.isEmpty) return;
    // Navigate to '/habit/:id' — adjust to your app routing
    print('➡️ Notification tapped, deep-link to habit/$habitId');
    Get.toNamed('/habit/$habitId');
  }

  Future<void> showImmediateHabitSavedNotification(String habitName) async {
    const android = AndroidNotificationDetails(
      'instant_test',
      'Instant Test Notifications',
      channelDescription: 'Fires instantly when a habit is saved',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: android,
      iOS: DarwinNotificationDetails(),
    );
    await _flutterLocal.show(
      DateTime.now().millisecondsSinceEpoch ~/ 2000,
      'Time is running out!',
      'Complete "$habitName" now!',
      details,
    );
  }

  // Helper functions using timezone package (main must call tz.initializeTimeZones() or we did it above)
  /// Convert a device-local clock time (hour/minute) into a tz.TZDateTime in the device's timezone.
  /// This ensures notifications fire at the correct local time.
  tz.TZDateTime _nextLocalInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    // Construct today's target time in device timezone
    var target = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    // If the time has already passed today, schedule for tomorrow
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }
    return target;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    return _nextLocalInstance(hour, minute);
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(int weekday, int hour, int minute) {
    var scheduled = _nextLocalInstance(hour, minute);
    // loop until weekday matches (weekdays use DateTime.weekday 1..7)
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Helper that schedules notifications with exact timing using exactAllowWhileIdle.
  ///
  /// IMPORTANT: AndroidManifest.xml must declare USE_EXACT_ALARM permission (Android 14+)
  /// instead of SCHEDULE_EXACT_ALARM. USE_EXACT_ALARM doesn't require user permission
  /// but may be subject to Play Store review for calendar/alarm clock apps.
  ///
  /// Returns true if scheduling succeeded, false if it failed.
  Future<bool> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    String? payload,
    DateTimeComponents? match,
  }) async {
    try {
      // Use exactAllowWhileIdle for precise timing
      // With USE_EXACT_ALARM in manifest, this should work without user permission
      await _flutterLocal.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: match,
      );
      return true;
    } on PlatformException catch (pe) {
      if (pe.code == 'exact_alarms_not_permitted') {
        // This should not happen with USE_EXACT_ALARM, but keeping fallback for safety
        print('⚠️ exact_alarms_not_permitted error (unexpected with USE_EXACT_ALARM)');
        print('   Check AndroidManifest.xml has USE_EXACT_ALARM permission');

        // Persist that exact alarms are denied so UI can inform the user
        try {
          _prefs ??= await SharedPreferences.getInstance();
          await _prefs?.setBool(_exactDeniedKey, true);
        } catch (_) {}

        try {
          // Fallback to inexactAllowWhileIdle (notifications may be delayed)
          print('   Falling back to inexact alarm mode (notifications may be delayed)');
          await _flutterLocal.zonedSchedule(
            id,
            title,
            body,
            scheduledDate,
            details,
            payload: payload,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: match,
          );
          return true;
        } catch (e) {
          // Scheduling still failed — log and return false
          print('⚠️ fallback zonedSchedule failed for id=$id: $e');
          return false;
        }
      } else {
        print('⚠️ PlatformException during scheduling: ${pe.code} ${pe.message}');
        return false;
      }
    } catch (e) {
      print('⚠️ _safeZonedSchedule unexpected error: $e');
      return false;
    }
  }

  // New helper to let app check whether exact alarms were denied on device
  Future<bool> isExactAlarmDenied() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getBool(_exactDeniedKey) ?? false;
  }

  // Whether any scheduling attempts previously failed on device
  Future<bool> hasSchedulingFailed() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs?.getBool(_schedulingFailedKey) ?? false;
  }

  // Optionally allow clearing flag (e.g. after user has granted permission)
  Future<void> clearExactAlarmDeniedFlag() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.remove(_exactDeniedKey);
  }

  /// Check if exact alarm permission is granted (Android 12+ / API 31+)
  /// Returns true if permission is granted or not required (iOS, older Android)
  Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) {
      return true; // iOS doesn't need this permission
    }

    try {
      final androidImpl = _flutterLocal.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        // Check if device can schedule exact alarms
        final canSchedule = await androidImpl.canScheduleExactNotifications();
        print('📍 Can schedule exact alarms: ${canSchedule ?? false}');
        return canSchedule ?? false;
      }
      return true; // Assume granted if we can't check
    } catch (e) {
      print('⚠️ Error checking exact alarm permission: $e');
      return true; // Assume granted on error
    }
  }

  /// Request exact alarm permission by opening system settings (Android 12+)
  Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    try {
      final androidImpl = _flutterLocal.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        // This opens the system settings page for exact alarms
        await androidImpl.requestExactAlarmsPermission();
        print('📍 Opened exact alarm permission settings');
      }
    } catch (e) {
      print('⚠️ Error requesting exact alarm permission: $e');
    }
  }
}
