package com.example.hybrid

import android.annotation.TargetApi
import android.app.*
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import kotlin.system.exitProcess

class MainService : Service() {

    override fun onCreate() {
        super.onCreate()
        keepForeground()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    @TargetApi(Build.VERSION_CODES.O)
    private fun keepForeground() {
        val channelOneId = packageName;
        val notification: Notification = Notification.Builder(this, channelOneId).build()
        val notificationManager: NotificationManager =
            getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(
            NotificationChannel(
                channelOneId,
                "Channel One",
                NotificationManager.IMPORTANCE_HIGH
            )
        );
        startForeground(1, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        exitProcess(0)
    }
}