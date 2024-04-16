// package com.example.ekagrata_app;

// import android.app.usage.UsageStats;
// import android.app.usage.UsageStatsManager;
// import android.content.Context;
// import android.os.Bundle;

// import java.util.List;

// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.plugin.common.MethodChannel;

// public class MainActivity extends FlutterActivity {

//     private static final String APP_USAGE_CHANNEL = "app_usage_channel";

//     @Override
//     protected void onCreate(Bundle savedInstanceState) {
//         super.onCreate(savedInstanceState);
//         collectAppUsageData();
//     }

//     private void collectAppUsageData() {
//         // Collect app usage data
//         UsageStatsManager usageStatsManager = (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
//         long endTime = System.currentTimeMillis();
//         long startTime = endTime - 1000 * 60 * 60 * 24; // For example, collect data for the past 24 hours
//         List<UsageStats> usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime);

//         // Filter usage data for Instagram app
//         long instagramTime = 0;
//         for (UsageStats usageStats : usageStatsList) {
//             if ("com.instagram.android".equals(usageStats.getPackageName())) {
//                 instagramTime += usageStats.getTotalTimeInForeground();
//             }
//         }

//         // Send data to Flutter app
//         MethodChannel methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), APP_USAGE_CHANNEL);
//         methodChannel.invokeMethod("updateInstagramTime", instagramTime);
//     }
// }
