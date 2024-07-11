import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationModel>(builder: (context, auth, _) {
      // print('AuthGuard rebuild: isAuthenticated = ${auth.isAuthenticated}');

      if (auth.isAuthenticated) {
        return child;
      } else {
        return const LoginPage();
      }
    });
  }
}
