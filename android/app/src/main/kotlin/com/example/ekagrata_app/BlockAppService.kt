package com.example.flutter_screentime

import android.app.AppOpsManager
import android.app.KeyguardManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Context.KEYGUARD_SERVICE
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

const val CHANNEL_ID = "BlockAppService_Channel_ID"
const val NOTIFICATION_ID = 1

class BlockAppService : Service() {

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null
    private val userApps = mutableListOf<ResolveInfo>() // Use mutable list for app management

    private val params = WindowManager.LayoutParams(
        WindowManager.LayoutParams.MATCH_PARENT,
        WindowManager.LayoutParams.MATCH_PARENT,
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else WindowManager.LayoutParams.TYPE_PHONE,
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT
    )

    private fun isDeviceLocked(context: Context): Boolean {
        val keyguardManager = context.getSystemService(KEYGUARD_SERVICE) as KeyguardManager
        return keyguardManager.isKeyguardLocked
    }

    // Function to check for UsageStats permission (important for Android 11+)
    private fun hasUsageStatsPermission(context: Context): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(AppOpsManager.OP_GET_USAGE_STATS, context.applicationInfo.uid, context.packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun blockApps() {
        val intent = Intent(Intent.ACTION_MAIN, null)
            .addCategory(Intent.CATEGORY_LAUNCHER)
        val apps: List<ResolveInfo> = packageManager.queryIntentActivities(intent, 0)

        fun isAppInForeground(context: Context): Boolean {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val endTime = System.currentTimeMillis()
            val beginTime = endTime - 1000 * 60 * 60 * 24 * 3 // 3 days

            val usageEvents = usageStatsManager.queryEvents(beginTime, endTime)
            var lastEvent: UsageEvents.Event? = null
            while (usageEvents.hasNextEvent()) {
                val event = UsageEvents.Event()
                usageEvents.getNextEvent(event)
                if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                    lastEvent = event
                }
            }

            // Check if the most recent app is in the userApps list
            return lastEvent?.packageName?.let { packageName ->
                userApps.any { it.activityInfo.packageName == packageName }
            } ?: false
        }

        fun isLauncherApp(resolveInfo: ResolveInfo, context: Context): Boolean {
            val intent = Intent(Intent.ACTION_MAIN)
                .addCategory(Intent.CATEGORY_HOME)
            val defaultLauncher = context.packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
            return resolveInfo.activityInfo.packageName == defaultLauncher?.activityInfo.packageName
        }

       fun blockApp() {
    val sharedPreferences = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
    val editor = sharedPreferences.edit()

    Handler(Looper.getMainLooper()).postDelayed({
        val shouldRunLogic = sharedPreferences.getBoolean("Blocking", false)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // Check for both Draw Overlays and Usage Stats permissions
            if (!Settings.canDrawOverlays(this@BlockAppService) || !hasUsageStatsPermission(this@BlockAppService)) {
                editor.putBoolean("isBlocking", false)
                editor.apply()
                return@postDelayed // Exit if permissions are not granted
            }
        }

        if (isAppInForeground(this@BlockAppService) && !isDeviceLocked(this@BlockAppService)) {
            if (!isOverlayDisplayed && shouldRunLogic && overlayView?.windowToken == null) {
                isOverlayDisplayed = true
                // Request foreground service notification (optional)
                createForegroundServiceNotification()
                windowManager?.addView(overlayView, params)
            } else if (isOverlayDisplayed && !shouldRunLogic || overlayView?.windowToken != null) {
                isOverlayDisplayed = false
                // Remove notification (if displayed)
                stopForeground(true)
                windowManager?.removeView(overlayView)
            }
        }
    }, 1000) // Check every second (adjust delay as needed)
}

// Function to create a foreground service notification (optional)
private fun createForegroundServiceNotification() {
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "BlockAppService Channel",
            NotificationManager.IMPORTANCE_MIN
        )
        channel.description = "Notification for BlockAppService"
        notificationManager.createNotificationChannel(channel)
    }

    val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
        .setContentTitle("ScreenTime Blocker")
        .setContentText("Blocking Apps...")
        .setSmallIcon(R.drawable.ic_launcher) // Replace with your app icon
        .setPriority(NotificationCompat.PRIORITY_LOW)

    startForeground(NOTIFICATION_ID, notificationBuilder.build())
}
