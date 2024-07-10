import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class AppUsageData {
  final ApplicationWithIcon app;
  final int usage; // Usage time in minutes

  AppUsageData({required this.app, required this.usage});
}

class GameAppWithIcon extends StatefulWidget {
  @override
  _GameAppWithIconState createState() => _GameAppWithIconState();
}

class _GameAppWithIconState extends State<GameAppWithIcon> {
  static const platform = MethodChannel('com.example.ekagrata_app'); //
  List<dynamic> appUsageStats = [];
  List<AppUsageData> _appsUsage = [];
  List<Application> _apps = [];
  List<Application> _gameApps = [];
  List<Application> _otherApps = [];
  List<AppUsageInfo> _infoList = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _fetchAppUsageStats();
      _getApps();
      getUsageStats();
    }
    // _loadAppUsageData();
  }

  // Future<void> _fetchAppUsageStats() async {
  //   try {
  //     print('Invoking getAppUsageStats method');
  //     final stats = await platform.invokeMethod('getAppUsageStats');
  //     print('Received app usage stats: $stats');
  //     setState(() {
  //       appUsageStats = stats.cast<dynamic>();
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to get app usage stats: ${e.message}');
  //   }
  // }

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

  getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(minutes: 1440));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() {
        _infoList = infoList;
      });
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  _getApps() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(minutes: 1440));

    try {
      AppUsage appUsage = AppUsage();
      List<AppUsageInfo> usageList =
          await appUsage.getAppUsage(startDate, endDate);

      List<AppUsageData> appsUsage = [];
      for (AppUsageInfo usageInfo in usageList) {
        Application? app = await DeviceApps.getApp(usageInfo.packageName);
        if (app != null && app is ApplicationWithIcon) {
          appsUsage
              .add(AppUsageData(app: app, usage: usageInfo.usage.inMinutes));
        }
      }

      List<Application> apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true,
      );

      setState(() {
        _apps = apps;
        _appsUsage = appsUsage;

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
    return SingleChildScrollView(
      child: Platform.isAndroid
          ? appUsageStats.isEmpty
              ? Center(
                  child: Text('No app usage data available'),
                )
              : ListView.builder(
                  // itemCount: appUsageStats.length, //new line added
                  itemCount: _apps.length,
                  itemBuilder: (BuildContext context, int index) {
                    final stat = appUsageStats[index];
                    Application app = _apps[index];
                    // AppUsageData appUsage = _appsUsage[index];
                    if (app is ApplicationWithIcon &&
                        app.category == ApplicationCategory.game) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
          : Center(
              child:
                  Text("App usage data is only available on Android devices"),
            ),
    );
  }
}
