package com.example.flutter_cas_app_main

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ✅ Create notification channel (Android 8.0+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "com.app.geofencing_notifications_channel", // must match Dart code
                "Geofencing Service",                       // visible in settings
                NotificationManager.IMPORTANCE_LOW          // silent priority
            )

            // ✅ Add description here
            channel.description = "Shows geofence foreground service notification"

            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
