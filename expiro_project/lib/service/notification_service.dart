import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../screens/homeScreen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // ── تهيئة الـ Notifications ──────────────────────────────
  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    // طلب إذن الـ notifications على Android 13+
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // ── جدولة notification لـ item معين ─────────────────────
  Future<void> scheduleItemNotification(Item item) async {
    final now = tz.TZDateTime.now(tz.local);

    // notification قبل يوم
    final notifyDate = item.expiryDate.subtract(const Duration(days: 1));
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      DateTime(notifyDate.year, notifyDate.month, notifyDate.day, 9, 0),
      tz.local,
    );

    // لو الساعة 9 عدت، بعت بعد دقيقتين من دلوقتي
    final tz.TZDateTime finalDate =
    scheduledDate.isBefore(now) ? now.add(const Duration(seconds: 4)) : scheduledDate;

    await _plugin.zonedSchedule(
      item.id,
      '🚨 Expiring Tomorrow!',
      '${item.name} is expiring tomorrow!',
      finalDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expiry_channel',
          'Expiry Notifications',
          channelDescription: 'Notifications for items expiring soon',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    // notification يوم الـ expiry
    final tz.TZDateTime expiryDay = tz.TZDateTime.from(
      DateTime(item.expiryDate.year, item.expiryDate.month, item.expiryDate.day, 9, 0),
      tz.local,
    );

    if (expiryDay.isAfter(now)) {
      await _plugin.zonedSchedule(
        item.id + 10000,
        '🚨 Expires Today!',
        '${item.name} expires today!',
        expiryDay,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_channel',
            'Expiry Notifications',
            channelDescription: 'Notifications for items expiring soon',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ── إلغاء notification لما تحذف item ────────────────────
  Future<void> cancelItemNotification(int itemId) async {
    await _plugin.cancel(itemId);
    await _plugin.cancel(itemId + 10000);
  }

  // ── إلغاء كل الـ notifications ──────────────────────────
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
  
}
Future<void> scheduleItemNotification(Item item) async {
  debugPrint('Scheduling notification for: ${item.name}'); // ← جديد
  var notifyDate;
  debugPrint('Notify date: $notifyDate');                   // ← جديد
  // ... باقي الكود
}