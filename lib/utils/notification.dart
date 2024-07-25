import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _initNotifications();
    await _requestPermissions();
    _setupMessageHandlers();
  }

  Future<void> _initNotifications() async {
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          print("handling foreground notification" + jsonDecode(details.payload!));
        }
      },
    );

    // //THIS SHOWS LOCAL NOTIFICATIONS WHEN APP IS IN FOREGROUND on IOS
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // //REQUESTING PERMISSION
  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print(await FirebaseMessaging.instance.getToken());
    }
  }

  void _setupMessageHandlers() {
    // //LISTENING TO NOTIFICATIONS WHILE ON FOREGROUNG
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    // //HANDLING NOTIFICATIONS WHILE ON BACKGROUND/TERMINATED
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      await showNotification(message);
    }
  }

  // //THIS SHOWS LOCAL NOTIFICATIONS WHEN APP IS IN FOREGROUND on ANDROID
  Future<void> showNotification(RemoteMessage message) async {
    print(message);
    var androidDetails = const AndroidNotificationDetails(
      'simpass_channel_id',
      'Simpass Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title ?? "Simpass",
      message.notification!.body ?? "Simpass",
      generalNotificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
