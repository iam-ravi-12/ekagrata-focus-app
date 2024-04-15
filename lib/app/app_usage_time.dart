import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageTime extends StatefulWidget {
  @override
  _AppUsageTimeState createState() => _AppUsageTimeState();
}

class _AppUsageTimeState extends State<AppUsageTime> {
  int appOpenCount = 0;

  @override
  void initState() {
    super.initState();
    _getAppOpenCount();
  }

  Future<void> _getAppOpenCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appOpenCount = prefs.getInt('appOpenCount') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Usage Stats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total App Opens: $appOpenCount',
              style: TextStyle(fontSize: 20),
            ),
            // You can display more usage statistics here
          ],
        ),
      ),
    );
  }
}
