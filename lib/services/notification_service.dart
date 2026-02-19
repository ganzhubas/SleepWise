import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for managing local notifications:
/// - Fallback alarm notification (safety net when app is killed)
/// - Bedtime reminder (daily)
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Notification IDs ──────────────────────────────────────────────────
  static const _fallbackAlarmId = 1001;
  static const _bedtimeReminderId = 1002;

  // ── Channel IDs ───────────────────────────────────────────────────────
  static const _alarmChannelId = 'sleepwise_alarm';
  static const _alarmChannelName = 'Будильник';
  static const _alarmChannelDesc =
      'Будильник SleepWise — страховочное уведомление';

  static const _reminderChannelId = 'sleepwise_reminder';
  static const _reminderChannelName = 'Напоминания';
  static const _reminderChannelDesc = 'Напоминание ложиться спать';

  // ── Initialization ────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create Android notification channels
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _alarmChannelId,
            _alarmChannelName,
            description: _alarmChannelDesc,
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            enableLights: true,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _reminderChannelId,
            _reminderChannelName,
            description: _reminderChannelDesc,
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
      }
    }

    _initialized = true;
  }

  /// Request notification permission (Android 13+ / iOS).
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    }
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  // ── Fallback alarm notification ───────────────────────────────────────

  /// Schedule a fallback alarm notification at the upper bound of the wake
  /// window. This fires if the app is killed before the in-app alarm triggers.
  Future<void> scheduleFallbackAlarm({
    required TimeOfDay alarmTime,
  }) async {
    await init();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      alarmTime.hour,
      alarmTime.minute,
    );
    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      _fallbackAlarmId,
      'Пора просыпаться!',
      'Ваш будильник SleepWise сработал',
      tzScheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _alarmChannelId,
          _alarmChannelName,
          channelDescription: _alarmChannelDesc,
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
          playSound: true,
          enableVibration: true,
          ongoing: true,
          autoCancel: false,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel the scheduled fallback alarm (called when user wakes up normally).
  Future<void> cancelFallbackAlarm() async {
    await _plugin.cancel(_fallbackAlarmId);
  }

  // ── Bedtime reminder ──────────────────────────────────────────────────

  /// Schedule a daily bedtime reminder at the given time.
  Future<void> scheduleBedtimeReminder({
    required int hour,
    required int minute,
  }) async {
    await init();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      _bedtimeReminderId,
      'Пора готовиться ко сну',
      'Установите будильник в SleepWise',
      tzScheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _reminderChannelId,
          _reminderChannelName,
          channelDescription: _reminderChannelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.reminder,
          actions: const [
            AndroidNotificationAction(
              'open_alarm',
              'Установить будильник',
              showsUserInterface: true,
            ),
          ],
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // daily recurring
    );
  }

  /// Cancel the bedtime reminder.
  Future<void> cancelBedtimeReminder() async {
    await _plugin.cancel(_bedtimeReminderId);
  }

  // ── Utilities ─────────────────────────────────────────────────────────

  /// Cancel all pending notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
