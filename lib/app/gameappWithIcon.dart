import 'package:ekagrata_app/app/AppUsageTracker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

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
  List<AppUsageData> _appsUsage = [];
  List<Application> _apps = [];
  List<Application> _gameApps = [];
  List<Application> _otherApps = [];
  List<AppUsageInfo> _infoList = [];

  @override
  void initState() {
    super.initState();
    _getApps();
    getUsageStats();
    // _loadAppUsageData();
  }

  // _loadAppUsageData() async {
  //   final packageNames = ['com.example.app1', 'com.example.app2'];
  //   final usageData = await AppUsageTracker.getAppUsageData(packageNames);
  //   setState(() {
  //     _appUsageData = usageData;
  //   });
  // }

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

      // List<Application> gameApps = [];
      // List<Application> otherApps = [];

      // for (Application app in apps) {
      //   if (app.category == ApplicationCategory.game) {
      //     gameApps.add(app);
      //     print(app);
      //   } else {
      //     otherApps.add(app);
      //     print(app);
      //   }
      // }

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
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (BuildContext context, int index) {
        Application app = _apps[index];
        // AppUsageData appUsage = _appsUsage[index];
        if (app is ApplicationWithIcon &&
            app.category == ApplicationCategory.game) {
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
                subtitle:
                    // Text('Usage: ${_infoList[index].usage.inMinutes} minutes'),
                    Text('Usage: 10 minutes'),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
