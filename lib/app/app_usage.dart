import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_usage_time.dart';

class AppUsage extends StatefulWidget {
  @override
  _AppUsageState createState() => _AppUsageState();
}

class _AppUsageState extends State<AppUsage> {
  @override
  void initState() {
    super.initState();
    _trackAppUsage();
  }

  Future<void> _trackAppUsage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int appOpenCount = (prefs.getInt('appOpenCount') ?? 0) + 1;
    await prefs.setInt('appOpenCount', appOpenCount);
    // You can do more with the usage tracking here, such as storing timestamps, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the App'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppUsageTime()),
                );
              },
              child: Text('View Usage Stats'),
            ),
          ],
        ),
      ),
    );
  }
}
