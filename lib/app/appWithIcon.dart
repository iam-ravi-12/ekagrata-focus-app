import 'package:ekagrata_app/app/AppUsageTracker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'dart:io';
import 'app_usage_tracker.dart';
// import 'package:flutter/app_usage_tracker.dart';

class AppUsageData {
  final ApplicationWithIcon app;
  final int usage; // Usage time in minutes

  AppUsageData({required this.app, required this.usage});
}

class AppWithIcon extends StatefulWidget {
  @override
  _AppWithIconState createState() => _AppWithIconState();
}

class _AppWithIconState extends State<AppWithIcon> {
  static const platform = MethodChannel('com.example.ekagrata_app'); //
  List<dynamic> appUsageStats = [];
  List<AppUsageData> _appsUsage = [];
  List<Application> _apps = [];
  List<Application> _gameApps = [];
  List<Application> _otherApps = [];
  List<AppUsageInfo> _infoList = [];
  Map<String, AppUsageData> _appUsageData = {};

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _fetchAppUsageStats();
      _getApps();
      // getUsageStats();
    }
    // _loadAppUsageData();
  }

  Future<void> _fetchAppUsageStats() async {
    try {
      print('Invoking getAppUsageStats method');
      final stats = await platform.invokeMethod('getAppUsageStats');
      print('Received app usage stats: $stats');
      setState(() {
        appUsageStats = stats.cast<dynamic>();
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Handle permission denied case
        print('Usage stats permission denied');
      } else {
        print('Failed to get app usage stats: ${e.message}');
      }
    }
  }

  // _loadAppUsageData() async {
  //   final packageNames = ['com.example.app1', 'com.example.app2'];
  //   final usageData = await AppUsageTracker.getAppUsageData(packageNames);
  //   setState(() {
  //     _appUsageData = usageData;
  //   });
  // }

  // Future<void> _loadAppUsageData() async {
  //   try {
  //     final usageData = await AppUsageTracker.getAppUsageData();
  //     setState(() {
  //       _appUsageData = usageData;
  //       _appsUsage = usageData.values.toList();
  //     });
  //   } catch (error) {
  //     print("Error getting app usage data: $error");
  //   }
  // }

  // getUsageStats() async {
  //   try {
  //     DateTime endDate = DateTime.now();
  //     DateTime startDate = endDate.subtract(Duration(minutes: 1440));
  //     List<AppUsageInfo> infoList =
  //         await AppUsage().getAppUsage(startDate, endDate);
  //     setState(() {
  //       _infoList = infoList;
  //     });
  //   } on AppUsageException catch (exception) {
  //     print(exception);
  //   }
  // }

  _getApps() async {
    // DateTime endDate = DateTime.now();
    // DateTime startDate = endDate.subtract(Duration(minutes: 1440));

    try {
      // AppUsage appUsage = AppUsage();
      // List<AppUsageInfo> usageList =
      //     await appUsage.getAppUsage(startDate, endDate);

      // **Placement Here:**
      // List<Future<AppUsageData?>> appsUsages = usageList.map((usageInfo) async {
      //   Application? app = await DeviceApps.getApp(usageInfo.packageName);
      //   return app != null ? AppUsageData( usage: usageInfo.usage.inMinutes) : null;
      // }).where((appUsage) => appUsage != null).toList();

      // List<AppUsageData> appsUsage = [];
      // for (AppUsageInfo usageInfo in usageList) {
      //   Application? app = await DeviceApps.getApp(usageInfo.packageName);
      //   if (app != null && app is ApplicationWithIcon) {
      //     appsUsage
      //         .add(AppUsageData(app: app, usage: usageInfo.usage.inMinutes));
      //   }
      // }

      List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true,
      );

      List<Application> gameApps = [];
      List<Application> otherApps = [];

      for (Application app in apps) {
        if (app.category == ApplicationCategory.game) {
          gameApps.add(app);
          print(app);
        } else {
          otherApps.add(app);
          print(app);
        }
      }

      apps.sort((a, b) => a.appName.compareTo(b.appName));
      setState(() {
        _apps = apps;
        // _appsUsage = appsUsage;
        // _appsUsage = apps.map((app) => AppUsageData(app: app, usage: 0)).toList();
        _gameApps =
            _apps.where((app) => app.packageName.contains('game')).toList();
        _otherApps =
            _apps.where((app) => !app.packageName.contains('game')).toList();
      });
    } catch (e) {
      print("error getting app usage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Installed Apps'),
      ),
      body: ListView.builder(
        itemCount: _apps.length,
        // itemCount: _gameApps.length,
        // itemCount: _appsUsage.length,
        // itemCount: _appUsageData.length,
        // itemCount: _infoList.length,
        itemBuilder: (BuildContext context, int index) {
          // final appUsage = _appsUsage[index];
          // final app = appUsage.app;
          // final packageName = _appUsageData.keys.toList()[index];
          // final usageTime = _appUsageData[packageName]!.usage;
          // Application app = _apps[index];
          final stat = appUsageStats[index];
          Application app = _apps[index];
          // AppUsageData app = _appsUsage[index];
          if (app is ApplicationWithIcon) {
            return Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),
                  child: ListTile(
                    leading: Image.memory(app.icon),
                    title: Text(app.appName),
                    subtitle: Text('Usage time: ${stat['usageTime']}'),
                    // subtitle:
                    //     Text(formatDuration(Duration(minutes: appUsage.usage))),
                  ),
                ));
          } else {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(),
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey[300],
              ),
              child: ListTile(
                title: Text(app.appName),
              ),
            );
          }
        },
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
