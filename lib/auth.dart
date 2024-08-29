import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/chat_button.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
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

    Provider.of<WebSocketModel>(context, listen: false).connect();
  }

  @override
  void dispose() {
    // Provider.of<WebSocketModel>(context, listen: false).disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopNow,
      onPopInvokedWithResult: (didPop, result) {
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
          // return Scaffold(
          //   drawer: const SideMenu(),
          //   appBar: AppBar(),
          //   body: widget.child,
          // );
          return SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                widget.child,
                const ChatButton(),
              ],
            ),
          );
        } else {
          return const LoginPage();
        }
      }),
    );
  }
}
