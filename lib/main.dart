import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/pages/plans.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/profile.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';
import 'package:mobile_manager_simpass/theme.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
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
      initialRoute: '/forms',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),

        //protected
        '/home': (context) => const AuthGuard(child: HomePage()),
        '/profile': (context) => const AuthGuard(child: ProfilePafe()),

        '/forms': (context) => const AuthGuard(child: PlansPage()),
        '/rental-forms': (context) => const AuthGuard(child: HomePage()),
        '/applications': (context) => const AuthGuard(child: HomePage()),
        '/download-forms': (context) => const AuthGuard(child: HomePage()),
      },
      theme: AppTheme.lightTheme,
    );
  }
}
