import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class AppUsageTracker {
//   static const _channel = MethodChannel('com.example.app/app_usage_tracker');

//   static Future<Map<String, AppUsageData>> getAppUsageData(
//       List<String> packageNames) async {
//     try {
//       final usageData = await _channel
//           .invokeMethod<Map<dynamic, dynamic>>('getAppUsageData', packageNames);
//       return usageData?.cast<String, AppUsageData>() ?? {};
//     } on PlatformException catch (e) {
//       print('Failed to get app usage data: ${e.message}');
//       return {};
//     }
//   }
// }

class AppUsageTracker {
  static const _channel = MethodChannel('com.example.ekagrata_app/app_usage_tracker');

  static Future<Map<String, AppUsageData>> getAppUsageData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dailyLimit = prefs.getInt('dailyLimit') ?? 0;
      final weeklyLimit = prefs.getInt('weeklyLimit') ?? 0;

      final usageData = await _channel
          .invokeMethod<Map<dynamic, dynamic>>('getAppUsageData', {
        'dailyLimit': dailyLimit,
        'weeklyLimit': weeklyLimit,
      });
      return usageData?.cast<String, AppUsageData>() ?? {};
    } on PlatformException catch (e) {
      print('Failed to get app usage data: ${e.message}');
      return {};
    }
  }
}

class AppUsageData {
  final int dailyUsageTime;
  final int weeklyUsageTime;
  final int launchCount;

  AppUsageData({
    required this.dailyUsageTime,
    required this.weeklyUsageTime,
    required this.launchCount,
  });

  factory AppUsageData.fromMap(Map<dynamic, dynamic> map) {
    return AppUsageData(
      dailyUsageTime: map['dailyUsageTime'] as int,
      weeklyUsageTime: map['weeklyUsageTime'] as int,
      launchCount: map['launchCount'] as int,
    );
  }
}
