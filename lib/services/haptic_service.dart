import 'package:flutter/services.dart';

/// A service to provide consistent haptic feedback across the application.
class HapticService {
  /// Light impact for subtle interactions like scrolling through a list or switching tabs.
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact for more significant actions like long presses or opening a modal.
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact for critical or high-stakes actions.
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click for discrete selection changes.
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Success feedback (vibrate) for completed actions.
  static Future<void> success() async {
    await HapticFeedback.vibrate();
  }
}
