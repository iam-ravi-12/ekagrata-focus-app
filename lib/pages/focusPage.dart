import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const methodChannel = MethodChannel('ekagrata_app');

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                var result = 'approved';
                if (Platform.isAndroid) {
                  result = await methodChannel.invokeMethod('checkPermission')
                      as String;
                }
                debugPrint('[DEBUG]result: $result');
                if (result == 'approved') {
                  await methodChannel.invokeMethod('blockApp');
                } else {
                  debugPrint('[DEBUG]Permission not granted');
                  await methodChannel.invokeMethod('requestAuthorization');
                }
              },
              child: const Text('blockApp'),
            ),
            TextButton(
              onPressed: () {
                methodChannel.invokeMethod('unblockApp');
              },
              child: const Text('unblockApp'),
            ),
          ],
        ),
      ),
    );
  }
}
