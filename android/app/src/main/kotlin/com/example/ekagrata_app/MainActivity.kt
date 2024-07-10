// package com.example.ekagrata_app

// import android.app.*
// import android.app.usage.UsageEvents
// import android.app.usage.UsageStats
// import android.app.usage.UsageStatsManager
// import android.content.Context
// import android.content.Intent
// import android.content.pm.ApplicationInfo
// import android.content.pm.PackageManager
// import android.content.pm.ResolveInfo
// import android.graphics.PixelFormat
// import android.net.Uri
// import android.os.Build
// import android.os.Handler
// import android.os.Looper
// import android.provider.Settings
// import android.view.LayoutInflater
// import io.flutter.embedding.android.FlutterActivity
// import android.view.View
// import android.view.WindowManager
// import androidx.annotation.NonNull
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import kotlinx.coroutines.*
// import java.util.*
// import java.util.concurrent.TimeUnit
// import kotlin.collections.ArrayList
// import android.Manifest
// import androidx.annotation.RequiresApi
// import android.app.AppOpsManager



// var job = Job()
// val scope = CoroutineScope(Dispatchers.Default + job)

// class MainActivity: FlutterActivity() {

//     private val CHANNEL = "com.example.ekagrata_app"

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine)
//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//             when (call.method) {
//                 "getAppUsageStats" -> getAppUsageStats(this, result)
//                 else -> result.notImplemented()
//             }
//         }
//         val params = WindowManager.LayoutParams(
//             WindowManager.LayoutParams.MATCH_PARENT,
//             WindowManager.LayoutParams.MATCH_PARENT,
//             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else WindowManager.LayoutParams.TYPE_PHONE,
//             WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
//             PixelFormat.TRANSLUCENT
//         )
//         var isOverlayDisplayed = false
//         val userApps = ArrayList<ResolveInfo>()
//         val sharedPreferences = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
//         val editor = sharedPreferences.edit()

        




//         fun checkDrawOverlayPermission(activity: Activity): Boolean {
//                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                     if (!Settings.canDrawOverlays(activity)) {
//                         return false
//                     }
//                 }
//                 return true
//             }

//             fun requestDrawOverlayPermission(activity: Activity, requestCode: Int): Boolean {
//                 if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                     if (!Settings.canDrawOverlays(activity)) {
//                         val intent = Intent(
//                             Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                             Uri.parse("package:" + activity.packageName)
//                         )
//                         activity.startActivityForResult(intent, requestCode)
//                         return false
//                     }
//                 }
//                 return true
//             }

//         fun isServiceRunning(serviceClassName: String, context: Context): Boolean {
//             val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//             for (service in activityManager.getRunningServices(Integer.MAX_VALUE)) {
//                 if (serviceClassName == service.service.className) {
//                     return true
//                 }
//             }
//             return false
//         }

//         fun setAlarm(hour: Int, minute: Int, second: Int) {
//             val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        
//             val calendar = Calendar.getInstance().apply {
//                 timeInMillis = System.currentTimeMillis()
//                 set(Calendar.HOUR_OF_DAY, hour)
//                 set(Calendar.MINUTE, minute)
//                 set(Calendar.SECOND, second)
//             }
        
//             val intent = Intent(this, AlarmReceiver::class.java)
        
//             val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
//                 PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
//             } else {
//                 PendingIntent.FLAG_UPDATE_CURRENT
//             }
        
//             val pendingIntent = PendingIntent.getBroadcast(this, 0, intent, pendingIntentFlags)
        
//             alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, pendingIntent)
//         }
        
//         fun checkQueryAllPackagesPermission(context: Context): Boolean {
//             return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                 PackageManager.PERMISSION_GRANTED == context.checkSelfPermission(Manifest.permission.QUERY_ALL_PACKAGES)
//             } else {
//                 true
//             }
//         }

//         fun requestQueryAllPackagesPermission(activity: Activity): Boolean {
//             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
//                 if (activity.checkSelfPermission(Manifest.permission.QUERY_ALL_PACKAGES) != PackageManager.PERMISSION_GRANTED) {
//                     activity.requestPermissions(arrayOf(Manifest.permission.QUERY_ALL_PACKAGES), 2)
//                     return false
//                 }
//             }
//             return true
//         }

        

//         fun hasUsageStatsPermission(context: Context): Boolean {
//             val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
//             val mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
//             return mode == AppOpsManager.MODE_ALLOWED
//         }
        
//         fun requestUsageStatsPermission(context: Context) {
//             val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//             context.startActivity(intent)
//         }





//         super.configureFlutterEngine(flutterEngine)
//             MethodChannel(
//                 flutterEngine.dartExecutor.binaryMessenger,
//                 CHANNEL
//             ).setMethodCallHandler { call, result ->
//                 when (call.method) {

//                     "blockApp" -> {
//                         editor.putBoolean("Blocking", true)
//                         editor.putBoolean("isBlocking", true)
//                         editor.apply()

//                         val intent = Intent(this, BlockAppService::class.java)
//                         startForegroundService(intent)
//                         println("[DEBUG]blockApp")
//                         val isRunning = isServiceRunning(BlockAppService::class.java.name, context)
//                         println("[DEBUG]isRunning: $isRunning")

//                         result.success(null)
//                     }
//                     "unblockApp" -> {
//                         editor.putBoolean("Blocking", false)
//                         editor.apply()
//                         result.success(null)
//                     } "checkPermission" -> {
//                     val hasOverlayPermission = checkDrawOverlayPermission(this)
//                     val hasQueryPermission = checkQueryAllPackagesPermission(this)
//                     val hasUsageStatsPermission = hasUsageStatsPermission(this)

//                     if (hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission) {
//                         result.success("approved")
//                     } else {
//                         result.success("denied")
//                     }
//                 }
//                     "requestAuthorization" -> {
//                         val hasOverlayPermission = requestDrawOverlayPermission(this, 1234)
//                         val hasQueryPermission = requestQueryAllPackagesPermission(this)
//                         val hasUsageStatsPermission = hasUsageStatsPermission(this)
//                         if (!hasUsageStatsPermission) {
//                             requestUsageStatsPermission(this)
//                         }

//                         if (hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission) {
//                             result.success("approved")
//                         } else {
//                             result.success("denied")
//                         }
//                     }
//                     else -> {
//                         result.notImplemented()
//                     }
//                 }
//             }
//         }

//         private fun getAppUsageStats(context: Context, result: MethodChannel.Result) {
//             println("getAppUsageStats method called")
//             if (!hasPermission(context)) {
                
//                 val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//                 intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//                 context.startActivity(intent)
//                 requestUsageStatsPermission(context)
//                 result.error("PERMISSION_DENIED", "Usage stats permission denied", null)
//                 return
//             }
    
//             val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//             val calendar = Calendar.getInstance()
//             calendar.add(Calendar.YEAR, -1)
//             val queryUsageStats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_BEST, calendar.timeInMillis, System.currentTimeMillis())
    
//             val appUsageStats = mutableListOf<Map<String, Any>>()
//             val packageManager = context.packageManager
//             queryUsageStats.sortedByDescending { it.lastTimeUsed }.forEach { usageStat ->
//                 val appName = packageManager.getApplicationLabel(packageManager.getApplicationInfo(usageStat.packageName, 0)).toString()
//                 val usageTime = usageStat.totalTimeInForeground / 1000 / 60 // Convert to minutes
//                 appUsageStats.add(mapOf("appName" to appName, "usageTime" to usageTime))
//             }
    
//             result.success(appUsageStats)
//         }
    
//         private fun hasPermission(context: Context): Boolean {
//             val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
//             val mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
//             return mode == AppOpsManager.MODE_ALLOWED
//         }

// }



//new code from here

package com.example.ekagrata_app

import android.app.*
import android.app.usage.UsageEvents
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.PixelFormat
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.view.LayoutInflater
import io.flutter.embedding.android.FlutterActivity
import android.view.View
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.util.*
import java.util.concurrent.TimeUnit
import kotlin.collections.ArrayList
import android.Manifest
import androidx.annotation.RequiresApi
import android.app.AppOpsManager
import android.content.SharedPreferences
import android.annotation.SuppressLint

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.ekagrata_app"
    private lateinit var sharedPreferences: SharedPreferences
    

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sharedPreferences = getSharedPreferences("app_settings", Context.MODE_PRIVATE)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppUsageStats" -> getAppUsageStats(this, result)
                "blockApp" -> handleBlockApp(this, result)
                "unblockApp" -> handleUnblockApp(this, result)
                "checkPermission" -> checkPermission(this, result)
                "requestAuthorization" -> requestAuthorization(this, result)
                else -> result.notImplemented()
            }
        }
    }

    @SuppressLint("QueryPermissionsNeeded")
    private fun getAppUsageStats(context: Context, result: MethodChannel.Result) {
        println("getAppUsageStats method called")
        if (!hasUsageStatsPermission(context)) {
            requestUsageStatsPermission(context)
            result.error("PERMISSION_DENIED", "Usage stats permission denied", null)
            return
        }

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
    val startTime = endTime - 24 * 60 * 60 * 1000 // Start time is 24 hours ago

    val queryUsageStats = usageStatsManager.queryUsageStats(
        UsageStatsManager.INTERVAL_DAILY,
        startTime,
        endTime
    )
        // val calendar = Calendar.getInstance().apply {
        //     add(Calendar.DAY_OF_YEAR, -1)
        // }
        // val queryUsageStats = usageStatsManager.queryUsageStats(
        //     UsageStatsManager.INTERVAL_BEST,
        //     calendar.timeInMillis,
        //     System.currentTimeMillis()
        // )

        val appUsageStats = mutableListOf<Map<String, Any>>()
        val packageManager = context.packageManager
        queryUsageStats.sortedByDescending { it.lastTimeUsed }.forEach { usageStat ->
            val appName = packageManager.getApplicationLabel(packageManager.getApplicationInfo(usageStat.packageName, 0)).toString()
            val usageTime = usageStat.totalTimeInForeground / 1000 / 60 // Convert to minutes
            appUsageStats.add(mapOf("appName" to appName, "usageTime" to usageTime))
        }
        result.success(appUsageStats)
    }

    private fun handleBlockApp(context: Context, result: MethodChannel.Result) {
        // Handle blocking app logic

        val editor = sharedPreferences.edit()
        editor.putBoolean("Blocking", true)
        editor.putBoolean("isBlocking", true)
        editor.apply()

        val intent = Intent(context, BlockAppService::class.java)
        context.startForegroundService(intent)
        println("[DEBUG]blockApp")
        val isRunning = isServiceRunning(BlockAppService::class.java.name, context)
        println("[DEBUG]isRunning: $isRunning")


        result.success(null)
    }

    private fun handleUnblockApp(context: Context, result: MethodChannel.Result) {
        // Handle unblocking app logic

        val editor = sharedPreferences.edit()
        editor.putBoolean("Blocking", false)
        editor.apply()

        result.success(null)
    }

    private fun isServiceRunning(serviceClassName: String, context: Context): Boolean {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in activityManager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClassName == service.service.className) {
                return true
            }
        }
        return false
    }

    private fun checkPermission(context: Context, result: MethodChannel.Result) {
        val hasOverlayPermission = checkDrawOverlayPermission(context)
        val hasQueryPermission = checkQueryAllPackagesPermission(context)
        val hasUsageStatsPermission = hasUsageStatsPermission(context)

        if (hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission) {
            result.success("approved")
        } else {
            result.success("denied")
        }
    }

    private fun requestAuthorization(context: Context, result: MethodChannel.Result) {
        val hasOverlayPermission = requestDrawOverlayPermission(context, 1234)
        val hasQueryPermission = requestQueryAllPackagesPermission(context)
        if (!hasUsageStatsPermission(context)) {
            requestUsageStatsPermission(context)
        }

        if (hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission(context)) {
            result.success("approved")
        } else {
            result.success("denied")
        }
    }

    private fun hasUsageStatsPermission(context: Context): Boolean {
        val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun requestUsageStatsPermission(context: Context) {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        context.startActivity(intent)
    }

    // Other utility functions related to permissions and services
    private fun checkDrawOverlayPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return Settings.canDrawOverlays(context)
        }
        return true
    }

    private fun requestDrawOverlayPermission(context: Context, requestCode: Int): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(context)) {
                val intent = Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:${context.packageName}")
                )
                startActivityForResult(intent, requestCode)
                return false
            }
        }
        return true
    }

    private fun checkQueryAllPackagesPermission(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            PackageManager.PERMISSION_GRANTED == context.checkSelfPermission(Manifest.permission.QUERY_ALL_PACKAGES)
        } else {
            true
        }
    }

    private fun requestQueryAllPackagesPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            if (context.checkSelfPermission(Manifest.permission.QUERY_ALL_PACKAGES) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(arrayOf(Manifest.permission.QUERY_ALL_PACKAGES), 2)
                return false
            }
        }
        return true
    }
}



