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

//         channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example.ekagrata_app/app_usage_tracker")

//         channel.setMethodCallHandler(this)

//     }

//     override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

//         if (call.method == "getAppUsageData") {

//             // getAppUsageData(result)
//             val args = call.arguments as? Map<String, Int>
//             if (args != null) {
//                 val dailyLimit = args["dailyLimit"] ?: 0
//                 val weeklyLimit = args["weeklyLimit"] ?: 0
//                 getAppUsageData(dailyLimit, weeklyLimit, result)
//             } else {
//                 result.error("InvalidArguments", "Daily and weekly limits must be provided", null)
//             }

//         } else {

//             result.notImplemented()

//         }

        

//     }

//     // private fun getAppUsageData(dailyLimit: Int, weeklyLimit: Int,result: MethodChannel.Result) {

//     //     if (!isUsageStatsPermissionGranted()) {
//     //         val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//     //         intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//     //         context.startActivity(intent)
//     //         result.error("PermissionDenied", "Usage stats permission is required", null)
//     //         return
//     //     }

//     //     val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

//     //     val calendar = Calendar.getInstance()

//     //     val endTime = calendar.timeInMillis

//     //     calendar.add(Calendar.YEAR, -1)

//     //     val startTime = calendar.timeInMillis

//     //     val appUsageData = mutableMapOf<String, Int>()

//     //     val usageEvents = usageStatsManager.queryEvents(startTime, endTime)

//     //     while (usageEvents.hasNextEvent()) {

//     //         val event = UsageEvents.Event()
//     //         usageEvents.getNextEvent(event)
//     //         if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
//     //             val packageName = event.packageName
//     //             val eventTime = event.timeStamp
//     //             val usageTime = appUsageData.getOrDefault(packageName, 0) + (endTime - eventTime)
//     //             appUsageData[packageName] = usageTime
//     //         }
//     //     }
//     //     val resultMap = mutableMapOf<String, Map<String, Any>>()
//     //     for ((packageName, usageTime) in appUsageData) {
//     //         resultMap[packageName] = mapOf("usageTime" to usageTime)
//     //     }

//     //     //2
//     //     for (stats in usageStats) {
//     //         val packageName = stats.packageName
//     //         val totalTimeInForeground = stats.totalTimeInForeground
//     //         val dailyUsageTime = if (totalTimeInForeground < dailyLimit * 60000) totalTimeInForeground else dailyLimit * 60000
//     //         val weeklyUsageTime = if (totalTimeInForeground < weeklyLimit * 60000) totalTimeInForeground else weeklyLimit * 60000
//     //         appUsageData[packageName] = mapOf(
//     //             "dailyUsageTime" to (dailyUsageTime / 1000),
//     //             "weeklyUsageTime" to (weeklyUsageTime / 1000),
//     //             "launchCount" to 0 // Replace with actual launch count
//     //         )
//     //     }
//     //     //2

//     //     result.success(resultMap)

//     // }
//     private fun getAppUsageData(dailyLimit: Int, weeklyLimit: Int, result: MethodChannel.Result) {
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
//         calendar.add(Calendar.YEAR, -1)
//         val startTime = calendar.timeInMillis
    
//         val appUsageData = mutableMapOf<String, Map<String, Any>>()
    
//         val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
//         while (usageEvents.hasNextEvent()) {
//             val event = UsageEvents.Event()
//             usageEvents.getNextEvent(event)
//             if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
//                 val packageName = event.packageName
//                 val eventTime = event.timeStamp
//                 val totalTimeInForeground = endTime - eventTime
//                 val dailyUsageTime = if (totalTimeInForeground < dailyLimit * 60000) totalTimeInForeground else (dailyLimit * 60000).toLong()
//                 val weeklyUsageTime = if (totalTimeInForeground < weeklyLimit * 60000) totalTimeInForeground else (weeklyLimit * 60000).toLong()
//                 appUsageData[packageName] = mapOf(
//                     "dailyUsageTime" to (dailyUsageTime / 1000).toInt(),
//                     "weeklyUsageTime" to (weeklyUsageTime / 1000).toInt(),
//                     "launchCount" to 0 // Replace with actual launch count
//                 )
//             }
//         }
    
//         result.success(appUsageData)
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