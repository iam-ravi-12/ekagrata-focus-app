package com.example.flutter_screentime

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            Log.d("BootReceiver", "Device Boot Completed")
            val serviceIntent = Intent(context, BlockAppService::class.java)
            // Use startForegroundService for consistency across versions (if possible)
            if (Build.VERSION.SDK_INT >= Build.VERSION.CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        }
    }
}
