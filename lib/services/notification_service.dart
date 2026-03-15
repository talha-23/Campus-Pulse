import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/event.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Request permissions
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Setup FCM
    _setupFCM();
  }

  Future<NotificationSettings?> requestPermissions() async {
    try {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      return settings;
    } catch (e) {
      print('Error requesting permissions: $e');
      return null;
    }
  }

  void _setupFCM() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);

    // Handle when app is in background and opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message: ${message.messageId}');
    await _showLocalNotification(message);
  }

  Future<void> _handleInitialMessage(RemoteMessage? message) async {
    if (message != null) {
      print('App opened from terminated state: ${message.messageId}');
      _handleNotificationMessage(message);
    }
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print('App opened from background: ${message.messageId}');
    _handleNotificationMessage(message);
  }

  void _handleNotificationMessage(RemoteMessage message) {
    final String? eventId = message.data['eventId'];
    final String? type = message.data['type'];
    print('Notification data - EventId: $eventId, Type: $type');
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'campus_notify_channel',
      'Campus Notifications',
      channelDescription: 'Notifications for campus events',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['eventId'],
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    if (response.payload != null) {
      // Handle navigation
      print('Navigate to event: ${response.payload}');
    }
  }

// Schedule reminder for event
  Future<void> scheduleEventReminder(Event event) async {
    if (!event.isReminderSet || event.reminderTime == null) return;

    final scheduledDate = event.reminderTime!;
    final now = DateTime.now();

    if (scheduledDate.isBefore(now)) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'event_reminders',
      'Event Reminders',
      channelDescription: 'Reminders for upcoming events',
      importance: Importance.high,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    // Convert DateTime to TZDateTime
    final tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _localNotifications.zonedSchedule(
      event.hashCode,
      'Upcoming Event: ${event.title}',
      'Starts at ${_formatTime(event.date)}',
      tzScheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: event.id,
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
