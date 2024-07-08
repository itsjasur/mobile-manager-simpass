import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/models/appbar.dart';

import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final Widget child;

  const Wrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<AppbarModel>(context).title),
      ),
      drawer: const Drawer(),
      body: child,
    );
  }
}
