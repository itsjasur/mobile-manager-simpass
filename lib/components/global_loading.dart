import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/main.dart';

OverlayEntry? _overlayEntry;

void showGlobalLoading(bool active) {
  final overlay = navigatorKey.currentState!.overlay;
  if (overlay == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (active) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black54,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
      overlay.insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  });
}
