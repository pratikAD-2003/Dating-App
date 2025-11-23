import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimations {
  static void showSavedAnimation(
    BuildContext context,
    String animationPath, {
    int durationMs = 1200,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Lottie.asset(
              animationPath,
              width: 120,
              height: 120,
              repeat: false,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(
      Duration(milliseconds: durationMs),
    ).then((_) => entry.remove());
  }
}
