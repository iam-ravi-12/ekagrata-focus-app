import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grayscale_mode_channel.dart';

class GrayscaleSettings extends StatefulWidget {
  @override
  _GrayscaleSettingsState createState() => _GrayscaleSettingsState();
}

class _GrayscaleSettingsState extends State<GrayscaleSettings> {
  bool _isGrayscaleModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadGrayscaleSettings();
  }

  Future<void> _loadGrayscaleSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isGrayscaleModeEnabled =
          prefs.getBool('isGrayscaleModeEnabled') ?? false;
    });
  }

  Future<void> _saveGrayscaleSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGrayscaleModeEnabled', value);
    await setGrayscaleMode(value);
  }

  Future<void> setGrayscaleMode(bool enable) async {
    // Call the platform-specific code to enable/disable grayscale mode
    final result = await GrayscaleModeChannel.enableGrayscaleMode(enable);
    if (!result) {
      // Handle any errors or show a message to the user
      print('Failed to set grayscale mode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grayscale Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enable Grayscale Mode',
              style: Theme.of(context).textTheme.headline6,
            ),
            SwitchListTile(
              value: _isGrayscaleModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isGrayscaleModeEnabled = value;
                });
                _saveGrayscaleSettings(value);
              },
              title: Text(
                'Grayscale Mode',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
