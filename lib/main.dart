import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/pages/plans.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/profile.dart';
import 'package:mobile_manager_simpass/pages/secondary_signup.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';
import 'package:mobile_manager_simpass/pages/test.dart';
import 'package:mobile_manager_simpass/theme.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // initialRoute: '/test',
      initialRoute: '/plans',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/test': (context) => const TestPage(),
        '/secondary-signup': (context) => const SecondarySignup(name: 'name', phoneNumber: '01012312312', receiptId: '34523423432', certType: 'KAKAO', birthday: '19950534', employeeCode: 'asd'),

        //protected
        '/home': (context) => const AuthGuard(child: HomePage()),
        '/profile': (context) => const AuthGuard(child: ProfilePafe()),

        '/plans': (context) => const AuthGuard(child: PlansPage()),
        '/rental-forms': (context) => const AuthGuard(child: HomePage()),
        '/applications': (context) => const AuthGuard(child: HomePage()),
        '/download-forms': (context) => const AuthGuard(child: HomePage()),
      },
      theme: AppTheme.lightTheme,
    );
  }
}
