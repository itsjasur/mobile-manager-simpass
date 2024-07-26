import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initializes notifications and sets up message handlers
  Future<void> init() async {
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

    // Sets up local notifications plugin, configures settings for iOS and Android,
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        handleNotificationTap(details.payload);
      },
    );

    // Configure iOS foreground notification presentation options
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Handle notification taps when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      handleNotificationTap(jsonEncode(message?.data));
    });

    // Configures handlers for FCM messages in foreground, background, and when opening the app from a notification
    FirebaseMessaging.onMessage.listen(_showLocationNotification);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      handleNotificationTap(jsonEncode(message?.data));
    });
  }

  // Requests notification permissions from the user and returns the FCM token if authorized
  Future<String?> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      badge: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return await FirebaseMessaging.instance.getToken();
    }

    return null;
  }

  // Creates and displays a local notification using the FCM message content
  Future<void> _showLocationNotification(RemoteMessage? message) async {
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
      message?.notification?.title,
      message?.notification?.body,
      generalNotificationDetails,
      payload: jsonEncode(message?.data),
    );
  }

//this recaives payload as string and then converts to map
  void handleNotificationTap(String? payload) {
    // print('handlenotificationtap: $payload');
    if (payload != null) print(jsonDecode(payload));
  }
}

// Handles FCM messages when the app is in the background or terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("received background notification : $message");
}
