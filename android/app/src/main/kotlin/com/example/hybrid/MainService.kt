package com.example.hybrid

import android.app.*
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import kotlin.system.exitProcess

class MainService : Service() {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        keepForeground()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun keepForeground() {
        val channelOneId = packageName;
        NotificationChannel(channelOneId, "Channel One", NotificationManager.IMPORTANCE_HIGH);
        val notification: Notification = Notification.Builder(this, channelOneId).build()
        startForeground(1, notification)
    }

    override fun onDestroy() {
        super.onDestroy()
        exitProcess(0)
    }
}