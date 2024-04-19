import 'package:flutter/services.dart';

class AppUsageTracker {

  static const _channel = MethodChannel('com.example.ekagrata_app/app_usage_tracker');

  static Future<Map<String, AppUsageData>> getAppUsageData() async {

    try {

      final usageData = await _channel.invokeMethod<Map<dynamic, dynamic>>('getAppUsageData');

      return usageData?.cast<String, AppUsageData>() ?? {};

    } on PlatformException catch (e) {

      print('Failed to get app usage data: ${e.message}');

      return {};

    }

  }

}

class AppUsageData {

  final int usageTime;

  AppUsageData({required this.usageTime});

  factory AppUsageData.fromMap(Map<dynamic, dynamic> map) {

    return AppUsageData(

      usageTime: map['usageTime'] as int,

    );

  }

}