import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LimitSettings extends StatefulWidget {
  @override
  _LimitSettingsState createState() => _LimitSettingsState();
}

class _LimitSettingsState extends State<LimitSettings> {
  int? dailyLimit;
  int? weeklyLimit;

  @override
  void initState() {
    super.initState();
    _loadLimits();
  }

  Future<void> _loadLimits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dailyLimit = prefs.getInt('dailyLimit') ?? 0;
      weeklyLimit = prefs.getInt('weeklyLimit') ?? 0;
    });
  }

  Future<void> _saveLimits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyLimit', dailyLimit ?? 0);
    await prefs.setInt('weeklyLimit', weeklyLimit ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Limits'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Limit (minutes)',
              ),
              onChanged: (value) {
                setState(() {
                  dailyLimit = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weekly Limit (minutes)',
              ),
              onChanged: (value) {
                setState(() {
                  weeklyLimit = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveLimits,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}