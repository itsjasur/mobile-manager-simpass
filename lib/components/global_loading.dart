// import 'package:flutter/material.dart';
// import 'package:mobile_manager_simpass/main.dart';

// OverlayEntry? _overlayEntry;

// void showGlobalLoading(bool active) {
//   final overlay = navigatorKey.currentState!.overlay;
//   if (overlay == null) return;

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     if (active) {
//       _overlayEntry = OverlayEntry(
//         builder: (context) => Material(
//           color: Colors.black54,
//           child: Center(
//             child: CircularProgressIndicator(
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//         ),
//       );
//       overlay.insert(_overlayEntry!);
//     } else {
//       _overlayEntry?.remove();
//       _overlayEntry = null;
//     }
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile_manager_simpass/main.dart';

OverlayEntry? _overlayEntry;
bool _isOverlayQueued = false;

void showGlobalLoading(bool active) {
  // If we're in the middle of a frame, defer the overlay update
  if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
    if (!_isOverlayQueued) {
      _isOverlayQueued = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _isOverlayQueued = false;
        showGlobalLoading(active);
      });
    }
    return;
  }

  final overlay = navigatorKey.currentState?.overlay;
  if (overlay == null) return;

  if (active && _overlayEntry == null) {
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
  } else if (!active && _overlayEntry != null) {
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}
