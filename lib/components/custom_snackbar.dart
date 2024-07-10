// import 'package:flutter/material.dart';
// import 'package:mobile_manager_simpass/main.dart';

// // Global variable to keep track of the current SnackBar
// OverlayEntry? _currentSnackBar;

// void showCustomSnackBar(String message) {
//   final overlay = navigatorKey.currentState!.overlay;
//   if (overlay == null) return;

//   // If there's an existing SnackBar, remove it
//   _currentSnackBar?.remove();

//   OverlayEntry overlayEntry = OverlayEntry(
//     builder: (context) => Positioned(
//       top: 50,
//       left: 20,
//       right: 20,
//       child: Material(
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(4),
//         color: Colors.black87,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Text(
//             message,
//             style: const TextStyle(color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     ),
//   );

//   // Set the new SnackBar as the current one
//   _currentSnackBar = overlayEntry;

//   overlay.insert(overlayEntry);

//   Future.delayed(const Duration(seconds: 5), () {
//     // Only remove if this is still the current SnackBar
//     if (_currentSnackBar == overlayEntry) {
//       overlayEntry.remove();
//       _currentSnackBar = null;
//     }
//   });
// }

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/main.dart';

OverlayEntry? _currentSnackBar;
AnimationController? _animationController;

void showCustomSnackBar(String message) {
  final overlay = navigatorKey.currentState!.overlay;
  if (overlay == null) return;

  // If there's an existing SnackBar, remove it
  _currentSnackBar?.remove();
  _animationController?.dispose();

  // Create an AnimationController
  _animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: overlay,
  );

  final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -1.0),
  ).animate(CurvedAnimation(
    parent: _animationController!,
    curve: Curves.easeIn,
  ));

  void removeSnackBar() {
    _currentSnackBar?.remove();
    _currentSnackBar = null;
    _animationController?.dispose();
    _animationController = null;
  }

  Widget snackBarContent = GestureDetector(
    onVerticalDragUpdate: (details) {
      if (details.primaryDelta! < 0) {
        // Dragging upwards
        _animationController!.value -= details.primaryDelta! / 100;
      }
    },
    onVerticalDragEnd: (details) {
      if (_animationController!.value > 0.3 || details.primaryVelocity! < -700) {
        // If dragged more than 30% up or with a fast upward velocity, complete the dismissal
        _animationController!.forward().then((_) => removeSnackBar());
      } else {
        // Otherwise, return to the original position
        _animationController!.reverse();
      }
    },
    child: Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(4),
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SlideTransition(
            position: offsetAnimation,
            child: snackBarContent,
          ),
        ),
      ),
    ),
  );

  _currentSnackBar = overlayEntry;
  overlay.insert(overlayEntry);

  // Auto-dismiss after 5 seconds if not manually dismissed
  Future.delayed(const Duration(seconds: 4), () {
    if (_currentSnackBar == overlayEntry && _animationController != null) {
      _animationController!.forward().then((_) => removeSnackBar());
    }
  });
}
