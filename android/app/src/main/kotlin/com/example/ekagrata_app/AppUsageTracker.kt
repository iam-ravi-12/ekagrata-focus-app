// package com.example.ekagrata_app

// import android.app.usage.UsageEvents
// import android.app.usage.UsageStatsManager
// import android.content.Context
// import android.content.Intent
// import android.provider.Settings
// import io.flutter.embedding.engine.plugins.FlutterPlugin
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler
// import java.util.Calendar

// class AppUsageTrackerPlugin : FlutterPlugin, MethodCallHandler {
//     private lateinit var context: Context
//     private lateinit var channel: MethodChannel

//     override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//         context = flutterPluginBinding.applicationContext
//         channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.app/AppUsageTracker")
//         channel.setMethodCallHandler(this)
//     }

//     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//         if (call.method == "getAppUsageData") {
//             val packageNames = call.arguments<List<String>>()
//             if (packageNames != null) {
//                 getAppUsageData(packageNames, result)
//             } else {
//                 result.error("InvalidArguments", "Package names must be provided", null)
//             }
//         } else {
//             result.notImplemented()
//         }
//     }

//     private fun getAppUsageData(packageNames: List<String>, result: MethodChannel.Result) {
//         if (!isUsageStatsPermissionGranted()) {
//             val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//             intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//             context.startActivity(intent)
//             result.error("PermissionDenied", "Usage stats permission is required", null)
//             return
//         }

//         val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//         val calendar = Calendar.getInstance()
//         val endTime = calendar.timeInMillis
//         calendar.add(Calendar.DAY_OF_YEAR, -1)
//         val startTimeDailyRange = calendar.timeInMillis
//         calendar.add(Calendar.WEEK_OF_YEAR, -1)
//         val startTimeWeeklyRange = calendar.timeInMillis

//         val appUsageData = mutableMapOf<String, MutableMap<String, Any>>()

//         val usageEvents = usageStatsManager.queryEvents(startTimeWeeklyRange, endTime)
//         while (usageEvents.hasNextEvent()) {
//             val event = UsageEvents.Event()
//             usageEvents.getNextEvent(event)
//             if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
//                 val packageName = event.packageName
//                 if (packageNames.contains(packageName)) {
//                     val usageData = appUsageData.getOrPut(packageName) { mutableMapOf() }
//                     usageData["launchCount"] = (usageData["launchCount"] as? Int ?: 0) + 1
//                     val eventTime = event.timeStamp
//                     if (eventTime >= startTimeDailyRange) {
//                         usageData["dailyUsageTime"] = (usageData["dailyUsageTime"] as? Int ?: 0) + (endTime - eventTime)
//                     }
//                     usageData["weeklyUsageTime"] = (usageData["weeklyUsageTime"] as? Int ?: 0) + (endTime - eventTime)
//                 }
//             }
//         }

//         val resultMap = mutableMapOf<String, Map<String, Any>>()
//         for ((packageName, usageData) in appUsageData) {
//             resultMap[packageName] = usageData.toMap()
//         }

//         result.success(resultMap)
//     }

//     private fun isUsageStatsPermissionGranted(): Boolean {
//         val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//         val packageName = context.packageName
//         val usageStats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, System.currentTimeMillis() - (24 * 60 * 60 * 1000), System.currentTimeMillis())
//         return usageStats.any { it.packageName == packageName }
//     }

//     override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//         channel.setMethodCallHandler(null)
//     }
// }

