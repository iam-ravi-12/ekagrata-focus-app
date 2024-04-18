import 'package:flutter/services.dart';

class GrayscaleModeChannel {
  static const _channel = MethodChannel('com.example.ekagrata_app/grayscale_mode');

  static Future<bool> enableGrayscaleMode(bool enable) async {
    try {
      final result = await _channel.invokeMethod('enableGrayscaleMode', enable);
      return result ?? false;
    } on PlatformException catch (e) {
      print('Failed to set grayscale mode: ${e.message}');
      return false;
    }
  }
}