import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/pages/applications.dart';
import 'package:mobile_manager_simpass/pages/download_forms.dart';
import 'package:mobile_manager_simpass/pages/partner_request_results.dart';
import 'package:mobile_manager_simpass/pages/partner_request.dart';
import 'package:mobile_manager_simpass/pages/plans.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/profile.dart';
// import 'package:mobile_manager_simpass/pages/secondary_signup.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';

import 'package:mobile_manager_simpass/theme.dart';
import 'package:mobile_manager_simpass/utils/notification.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final notificationService = NotificationService();
  await notificationService.init();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // //REQUESTING PERMISSION
  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   sound: true,
  //   badge: true,
  //   provisional: true,
  // );

  // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //   print(await FirebaseMessaging.instance.getToken());
  // }

  // //ios
  // const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
  //   requestAlertPermission: true,
  //   requestBadgePermission: true,
  //   requestSoundPermission: true,
  // );
  // //android
  // var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

  // var initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  //   iOS: initializationSettingsIOS,
  // );

  // flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse: (details) {
  //     if (details.payload != null) {
  //       print("handling foreground notification" + jsonDecode(details.payload!));
  //     }
  //   },
  // );

  // //THIS SHOWS LOCAL NOTIFICATIONS WHEN APP IS IN FOREGROUND
  // if (Platform.isIOS) {
  //   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  // Future<void> showNotification(RemoteMessage message) async {
  //   print(message);

  //   var androidDetails = const AndroidNotificationDetails(
  //     'simpass_channel_id',
  //     'Simpass Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   var iOSDetails = const DarwinNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: true,
  //     sound: 'default',
  //   );

  //   var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     message.notification!.title ?? "Simpass",
  //     message.notification!.body ?? "Simpass",
  //     generalNotificationDetails,
  //     payload: jsonEncode(message.data),
  //   );
  // }

  // //LISTENING TO NOTIFICATIONS WHILE ON FOREGROUNG
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //   if (message.notification != null) {
  //     await showNotification(message);
  //   }
  // });

  // //HANDLING NOTIFICATIONS WHILE ON BACKGROUND/TERMINATED
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        // initialRoute: '/login',
        // initialRoute: '/secondary-signup',
        // initialRoute: '/applications',
        // initialRoute: '/plans',
        // initialRoute: '/download-forms',
        // initialRoute: '/form-details',
        // initialRoute: '/partner-request',
        // initialRoute: '/partner-request-results',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          // '/secondary-signup': (context) => const SecondarySignup(name: 'name', phoneNumber: '01012312312', receiptId: '34523423432', certType: 'KAKAO', birthday: '19950534', employeeCode: 'asd'),

          //protected
          // '/form-details': (context) => const FormDetailsPage(planId: 4, searchText: ''),
          '/home': (context) => const AuthGuard(child: HomePage()),
          '/profile': (context) => const AuthGuard(child: ProfilePafe()),
          '/plans': (context) => const AuthGuard(child: PlansPage()),
          '/applications': (context) => const AuthGuard(child: ApplicationsPage()),
          '/download-forms': (context) => const AuthGuard(child: DownloadFormsPage()),

          '/partner-request': (context) => const AuthGuard(child: PartnerRequestPage()),
          '/partner-request-results': (context) => const AuthGuard(child: PartnerRequestResultsPage()),
        },
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
