
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppUsageTracker {
  static const platform = MethodChannel('app_usage_tracker');

  static Future<Map<String, dynamic>> getAppUsageWithIcons() async {
    try {
      final Map<String, dynamic> result =
          await platform.invokeMethod('getAppUsageWithIcons');
      return result;
    } on PlatformException catch (e) {
      print("Failed to get app usage with icons: '${e.message}'.");
      return {};
    }
  }
}

// Call getAppUsageWithIcons() to retrieve app usage data with icons

