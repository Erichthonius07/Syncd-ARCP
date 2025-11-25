import 'package:flutter/services.dart';

class AccessibilityService {
  static const channel = MethodChannel('com.syncd/accessibility');

  static Future<void> performTap(double x, double y) async {
    try {
      await channel.invokeMethod('performTap', {
        'x': x,
        'y': y,
      });
    } catch (e) {
      print('Error performing tap: $e');
    }
  }

  static Future<void> requestAccessibilityPermission() async {
    try {
      await channel.invokeMethod('requestAccessibilityPermission');
    } catch (e) {
      print('Error requesting accessibility permission: $e');
    }
  }

  static Future<bool> isAccessibilityServiceEnabled() async {
    try {
      final result = await channel.invokeMethod<bool>('isAccessibilityServiceEnabled');
      return result ?? false;
    } catch (e) {
      print('Error checking accessibility service status: $e');
      return false;
    }
  }

  static Future<void> startScreenCapture() async {
    try {
      await channel.invokeMethod('startScreenCapture');
    } catch (e) {
      print('Error starting screen capture: $e');
    }
  }
}
