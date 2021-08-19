package com.example.hybrid

import android.app.Service
import android.content.Intent
import android.content.pm.ActivityInfo
import android.graphics.BlendMode
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.PorterDuff
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi

class DemoService : Service() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager;

        val layoutParams1 = WindowManager.LayoutParams();
        layoutParams1.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams1.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams1.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams1.width = 300
        layoutParams1.height = 300
        layoutParams1.x = 50
        layoutParams1.y = 100

        val layoutParams2 = WindowManager.LayoutParams();
        layoutParams2.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams2.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams2.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams2.width = 300
        layoutParams2.height = 300
        layoutParams2.x = 500
        layoutParams2.y = 1000

        val layoutParams3 = WindowManager.LayoutParams();
        layoutParams3.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams3.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams3.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams3.width = 300
        layoutParams3.height = 300
        layoutParams3.x = 0
        layoutParams3.y = 1300


        windowManager.addView(MainActivity.flutterView1, layoutParams1)
        windowManager.addView(MainActivity.flutterView2, layoutParams2)
        windowManager.addView(MainActivity.flutterView3, layoutParams3)

        return super.onStartCommand(intent, flags, startId)
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}

