package com.example.flutter_screentime

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
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import androidx.core.content.PermissionChecker
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.util.*
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {

    private val CHANNEL = "flutter_screentime"
    private val job = Job()
    private val scope = CoroutineScope(Dispatchers.Default + job)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "blockApp" -> handleBlockApp(call, result)
                "unblockApp" -> handleUnblockApp(call, result)
                "checkPermission" -> handleCheckPermission(call, result)
                "requestAuthorization" -> handleRequestAuthorization(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private suspend fun handleBlockApp(call: MethodCall, result: MethodChannel.Result) {
        withContext(Dispatchers.IO) {
            val sharedPreferences = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
            val editor = sharedPreferences.edit()

            editor.putBoolean("Blocking", true)
            editor.putBoolean("isBlocking", true)
            editor.apply()

            val intent = Intent(this@MainActivity, BlockAppService::class.java)
            startForegroundService(intent)
            result.success(null)
        }
    }

    private fun handleUnblockApp(call: MethodCall, result: MethodChannel.Result) {
        val sharedPreferences = getSharedPreferences("app_settings", Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        editor.putBoolean("Blocking", false)
        editor.apply()
        result.success(null)
    }

    private fun handleCheckPermission(call: MethodCall, result: MethodChannel.Result) {
        val hasOverlayPermission = checkDrawOverlayPermission()
        val hasQueryPermission = checkQueryAllPackagesPermission()
        val hasUsageStatsPermission = hasUsageStatsPermission(this)

        val permissionsGranted = hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission
        result.success(if (permissionsGranted) "approved" else "denied")
    }

    private fun handleRequestAuthorization(call: MethodCall, result: MethodCall.Result) {
        val hasOverlayPermission = requestDrawOverlayPermission()
        val hasQueryPermission = checkQueryAllPackagesPermission()
        val hasUsageStatsPermission = hasUsageStatsPermission(this)

        if (!hasUsageStatsPermission) {
            requestUsageStatsPermission(this)
        }

        val permissionsGranted = hasOverlayPermission && hasQueryPermission && hasUsageStatsPermission
        result.success(if (permissionsGranted) "approved" else "denied")
    }

    private fun checkDrawOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    private fun requestDrawOverlayPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                val intent = Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package
