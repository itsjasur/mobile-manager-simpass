import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/appbar.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';
import 'package:mobile_manager_simpass/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
        ChangeNotifierProvider(create: (_) => AppbarModel()),
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
      debugShowCheckedModeBanner: false,
      initialRoute: '/signup',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),

        //protected
        '/home': (context) => const AuthGuard(child: HomePage()),
      },
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
    );
  }
}
