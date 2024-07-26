// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     await _initNotifications();
//     _setupMessageHandlers();
//   }

//   // //REQUESTING PERMISSION
//   Future<String?> requestPermissions() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       sound: true,
//       badge: true,
//       provisional: true,
//     );

//     //request permission and update token
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       return await FirebaseMessaging.instance.getToken();
//     }
//     return null;
//   }

//   Future<void> _initNotifications() async {
//     const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse details) {
//         _handleNotificationTap(details.payload);
//       },
//     );

//     // //THIS SHOWS LOCAL NOTIFICATIONS WHEN APP IS IN FOREGROUND on IOS
//     if (Platform.isIOS) {
//       await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }

//     // Handles notification taps when app is terminated
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         _handleNotificationTap(jsonEncode(message.data));
//       }
//     });
//   }

//   void _setupMessageHandlers() {
//     // //LISTENING TO NOTIFICATIONS WHILE ON FOREGROUNG
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     //HANDLING NOTIFICATIONS WHILE ON BACKGROUND/TERMINATED
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       _handleNotificationTap(jsonEncode(message.data));
//     });
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     if (message.notification != null) {
//       await _showNotification(message);
//     }
//   }

//   // //THIS SHOWS LOCAL NOTIFICATIONS WHEN APP IS IN FOREGROUND on ANDROID
//   Future<void> _showNotification(RemoteMessage message) async {
//     var androidDetails = const AndroidNotificationDetails(
//       'simpass_channel_id',
//       'Simpass Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     var iOSDetails = const DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//     );

//     var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       generalNotificationDetails,
//       payload: jsonEncode(message.data),
//     );
//   }

//   void _handleNotificationTap(String? payload) {
//     print('Notification tapped');
//     print('Payload: $payload');
//   }
// }

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message: $message");
//   // print(message.data);
// }
