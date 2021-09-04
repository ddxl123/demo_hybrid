package com.example.hybrid.test

import android.app.*
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import java.lang.String
import java.util.*

class TestService : Service() {

    private lateinit var windowManager: WindowManager

    private lateinit var layoutParams: WindowManager.LayoutParams

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        println("--------------- onStartCommand")

        val CHANNEL_ONE_ID = "com.primedu.cn";
        val CHANNEL_ONE_NAME = "Channel One";
        var notificationChannel: NotificationChannel? = null;
        notificationChannel = NotificationChannel(
            CHANNEL_ONE_ID,
            CHANNEL_ONE_NAME, NotificationManager.IMPORTANCE_HIGH
        );
        notificationChannel.enableLights(true);
        notificationChannel.lightColor = Color.RED;
        notificationChannel.setShowBadge(true);
        notificationChannel.lockscreenVisibility = Notification.VISIBILITY_PUBLIC;
        val manager: NotificationManager =
            getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(notificationChannel);

        val pendingIntent: PendingIntent =
            Intent(this, TestActivity::class.java).let { notificationIntent ->
                PendingIntent.getActivity(this, 0, notificationIntent, 0)
            }

        val notification: Notification = Notification.Builder(this, CHANNEL_ONE_ID)
            .setContentTitle("title")
            .setContentText("text")
            .setContentIntent(pendingIntent)
//            .setTicker(getText(R.string.ticker_text))
            .build()

// Notification ID cannot be 0.
        startForeground(1, notification)

        windowManager = getSystemService(Service.WINDOW_SERVICE) as WindowManager
        layoutParams = WindowManager.LayoutParams()

        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        // 可点击非悬浮窗部分。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        // 防止其他应用和当前应用返回键失效。
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
        layoutParams.gravity = Gravity.START or Gravity.TOP
        layoutParams.width = 100
        layoutParams.height = 100
        layoutParams.x = 100
        layoutParams.y = 100

        val button = Button(this)

        Handler(Looper.getMainLooper()).postDelayed({
            layoutParams.width = 800
            layoutParams.height = 800
            layoutParams.x = 300
            layoutParams.y = 800
            layoutParams.alpha = 1.0f
            windowManager.updateViewLayout(button, layoutParams)
            println("-------------- Thread2")
        }, 0)

        windowManager.addView(button, layoutParams)


        return super.onStartCommand(intent, flags, startId)
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}