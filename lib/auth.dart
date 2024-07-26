import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/utils/notification.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _canPopNow = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopNow,
      onPopInvoked: (didPop) {
        _canPopNow = true;
        setState(() {});

        Timer(const Duration(seconds: 2), () {
          _canPopNow = false;
          setState(() {});
        });

        showCustomSnackBar('앱을 종료하려면 뒤로 버튼을 두 번 누르세요.');
      },
      child: Consumer<AuthenticationModel>(builder: (context, auth, _) {
        // print('AuthGuard rebuild: isAuthenticated = ${auth.isAuthenticated}');

        if (auth.isAuthenticated) {
          return widget.child;
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}
