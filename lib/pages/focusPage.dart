// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import 'package:app_usage/app_usage.dart';

// class AppUsageData {
//   final ApplicationWithIcon app;
//   final int usage; // Usage time in minutes

//   AppUsageData({required this.app, required this.usage});
// }

// class FocusPage extends StatefulWidget {
//   @override
//   _FocusPageState createState() => _FocusPageState();
// }

// class _FocusPageState extends State<FocusPage> {
//   List<AppUsageData> _appsUsage = [];
//   List<Application> _apps = [];
//   List<Application> _gameApps = [];
//   List<Application> _otherApps = [];

//   @override
//   void initState() {
//     super.initState();

//     _getApps();
//   }

//   _getApps() async {
//     DateTime endDate = DateTime.now();
//     DateTime startDate = endDate.subtract(Duration(days: 1));

//     AppUsage appUsage = AppUsage();
//     List<AppUsageInfo> usageList =
//         await appUsage.getAppUsage(startDate, endDate);

//     List<AppUsageData> appsUsage = [];
//     for (AppUsageInfo usageInfo in usageList) {
//       Application? app = await DeviceApps.getApp(usageInfo.packageName);
//       if (app != null && app is ApplicationWithIcon) {
//         appsUsage.add(AppUsageData(app: app, usage: usageInfo.usage.inMinutes));
//       }
//     }

//     List<Application> apps = await DeviceApps.getInstalledApplications(
//       onlyAppsWithLaunchIntent: true,
//       includeSystemApps: true,
//       includeAppIcons: true,
//     );
//     // apps.sort((a, b) => a.appName.compareTo(b.appName));
//     setState(() {
//       _apps = apps;
//       _appsUsage = appsUsage;
//       // _appsUsage = apps.map((app) => AppUsageData(app: app, usage: 0)).toList();
//       _gameApps =
//           _apps.where((app) => app.packageName.contains('game')).toList();
//       _otherApps =
//           _apps.where((app) => !app.packageName.contains('game')).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Installed Apps'),
//       ),
//       // body: ListView.builder(
//       //   itemCount: _apps.length,
//       //   itemBuilder: (BuildContext context, int index) {
//       //     Application app = _apps[index];
//       //     AppUsageData appUsage = _appsUsage.firstWhere(
//       //       (usage) => usage.app.packageName == app.packageName,
//       //       orElse: () =>
//       //           AppUsageData(app: app, usage: 0), // Default usage if not found
//       //     );
//       //     if (app is ApplicationWithIcon) {
//       //       return Container(
//       //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       //         child: Container(
//       //           padding: EdgeInsets.symmetric(vertical: 10),
//       //           decoration: BoxDecoration(
//       //             border: Border(),
//       //             borderRadius: BorderRadius.circular(20),
//       //             color: Colors.grey[300],
//       //           ),
//       //           child: ListTile(
//       //             leading: Image.memory(app.icon),
//       //             title: Text(app.appName),
//       //             subtitle: Text("${appUsage.usage} minutes"), // Display usage
//       //           ),
//       //         ),
//       //       );
//       //     } else {
//       //       return Container(
//       //         padding: EdgeInsets.symmetric(vertical: 10),
//       //         decoration: BoxDecoration(
//       //           border: Border(),
//       //           borderRadius: BorderRadius.circular(25),
//       //           color: Colors.grey[300],
//       //         ),
//       //         child: ListTile(
//       //           title: Text(app.appName),
//       //         ),
//       //       );
//       //     }
//       //   },
//       // ),
//       body: ListView.builder(
//         itemCount: _apps.length,
//         itemBuilder: (BuildContext context, int index) {
//           Application app = _apps[index];
//           // AppUsageData appUsage = _appsUsage[index];
//           if (app is ApplicationWithIcon) {
//             return Container(
//               margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   border: Border(),
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.grey[300],
//                 ),
//                 child: ListTile(
//                   leading: Image.memory(app.icon),
//                   title: Text(app.appName),
//                   // subtitle: Text(appUsage.usage),
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 border: Border(),
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.grey[300],
//               ),
//               child: ListTile(
//                 title: Text(app.appName),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:app_usage/app_usage.dart';

class AppUsageData {
  final ApplicationWithIcon app;
  final int usage; // Usage time in minutes

  AppUsageData({required this.app, required this.usage});
}

class FocusPage extends StatefulWidget {
  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  List<AppUsageData> _appsUsage = [];

  @override
  void initState() {
    super.initState();
    _getAppUsage();
  }

  Future<void> _getAppUsage() async {
    DateTime endDate = DateTime.now();
    DateTime startDate =
        endDate.subtract(Duration(days: 1)); // Usage for the last 24 hours

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

      appsUsage.sort((a, b) => a.app.appName.compareTo(b.app.appName));

      setState(() {
        _appsUsage = appsUsage;
      });
    } catch (e) {
      print("Error getting app usage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Installed Apps'),
      ),
      body: ListView.builder(
        itemCount: _appsUsage.length,
        itemBuilder: (BuildContext context, int index) {
          AppUsageData appUsage = _appsUsage[index];
          return ListTile(
            leading: Image.memory(appUsage.app.icon),
            title: Text(appUsage.app.appName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: appUsage.usage != null
                      ? appUsage.usage / 1440
                      : 0.0, // Assuming usage is compared to a day (1440 minutes)
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Text(
                  '${appUsage.usage ?? 0} min', // Displaying usage time
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
