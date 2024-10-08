import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/pages/applications.dart';
import 'package:mobile_manager_simpass/pages/chat.dart';
import 'package:mobile_manager_simpass/pages/download_forms.dart';
import 'package:mobile_manager_simpass/pages/form_details.dart';
import 'package:mobile_manager_simpass/pages/htmls.dart';
import 'package:mobile_manager_simpass/pages/partner_request_results.dart';
import 'package:mobile_manager_simpass/pages/partner_request.dart';
import 'package:mobile_manager_simpass/pages/plans.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/profile.dart';
import 'package:mobile_manager_simpass/pages/secondary_signup.dart';
import 'package:mobile_manager_simpass/pages/settings.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';
import 'package:mobile_manager_simpass/theme.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final webSocketModel = WebSocketModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel(webSocketModel)),
        ChangeNotifierProvider(create: (_) => webSocketModel),
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
        // initialRoute: '/test-page',
        // initialRoute: '/htmls',
        initialRoute: '/home',
        // initialRoute: '/profile',
        // initialRoute: '/login',
        // initialRoute: '/secondary-signup',
        // initialRoute: '/applications',
        // initialRoute: '/plans',
        // initialRoute: '/settings',
        // initialRoute: '/chat-page',
        // initialRoute: '/download-forms',
        // initialRoute: '/signup',
        // initialRoute: '/form-details',
        // initialRoute: '/partner-request',
        // initialRoute: '/partner-request-results',

        routes: {
          '/login': (context) => const LoginPage(),
          // '/test-page': (context) => const TestPage(),
          '/signup': (context) => const SignupPage(),
          '/secondary-signup': (context) => const SecondarySignup(name: 'name', phoneNumber: '01012312312', receiptId: '34523423432', certType: 'KAKAO', birthday: '19950534', employeeCode: 'asd'),
          '/htmls': (context) => const HtmlsPage(),

          //protected
          '/form-details': (context) => const FormDetailsPage(planId: 157, searchText: ''),
          '/home': (context) => const AuthGuard(child: HomePage()),
          '/chat-page': (context) => const AuthGuard(child: ChatPage()),
          '/profile': (context) => const AuthGuard(child: ProfilePafe()),
          '/plans': (context) => const AuthGuard(child: PlansPage()),
          '/applications': (context) => const AuthGuard(child: ApplicationsPage()),
          '/download-forms': (context) => const AuthGuard(child: DownloadFormsPage()),

          '/partner-request': (context) => const AuthGuard(child: PartnerRequestPage()),
          '/partner-request-results': (context) => const AuthGuard(child: PartnerRequestResultsPage()),

          '/settings': (context) => const AuthGuard(child: SettingsPage()),
        },
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
