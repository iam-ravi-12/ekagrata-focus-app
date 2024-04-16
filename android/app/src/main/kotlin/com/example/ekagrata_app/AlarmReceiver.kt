package com.example.flutter_screentime

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val sharedPreferences: SharedPreferences? = context.getSharedPreferences(
            "app_settings",
            Context.MODE_PRIVATE
        )
        sharedPreferences?.edit()
            ?.putBoolean("Blocking", false)
            ?.apply()
    }
}
