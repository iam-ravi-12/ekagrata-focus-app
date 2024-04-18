// package com.example.ekagrata_app

// import android.app.Activity
// import android.content.Context
// import android.provider.Settings
// import android.view.accessibility.AccessibilityManager
// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler

// class GrayscaleModePlugin : FlutterPlugin, MethodCallHandler {
//     private lateinit var context: Context

//     override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//         context = flutterPluginBinding.applicationContext
//         val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.ekagrata_app/grayscale_mode")
//         channel.setMethodCallHandler(this)
//     }

//     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//         if (call.method == "enableGrayscaleMode") {
//             val enable = call.arguments as Boolean
//             val success = enableGrayscaleMode(enable)
//             result.success(success)
//         } else {
//             result.notImplemented()
//         }
//     }

//     private fun enableGrayscaleMode(enable: Boolean): Boolean {
//         val accessibilityManager = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
//         val isAccessibilityEnabled = accessibilityManager.isEnabled

//         if (!isAccessibilityEnabled) {
//             // Prompt the user to enable accessibility settings
//             val intent = accessibilityManager.accessibilityShortcutIntent
//             (context as Activity).startActivityForResult(intent, 0)
//             return false
//         }

//         val isGrayscaleModeEnabled = Settings.Secure.getString(
//             context.contentResolver,
//             Settings.Secure.ACCESSIBILITY_GRAYSCALE_ENABLED
//         ) == "1"

//         if (enable != isGrayscaleModeEnabled) {
//             Settings.Secure.putString(
//                 context.contentResolver,
//                 Settings.Secure.ACCESSIBILITY_GRAYSCALE_ENABLED,
//                 if (enable) "1" else "0"
//             )
//             return true
//         }

//         return false
//     }

//     override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//         // No-op
//     }
// }