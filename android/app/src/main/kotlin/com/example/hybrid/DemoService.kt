package com.example.hybrid

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class DemoService : Service() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager;
        val layoutParams = WindowManager.LayoutParams();
        layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams.width = 300
        layoutParams.height = 300
        layoutParams.x = 50
        layoutParams.y = 100


        val layoutParams2 = WindowManager.LayoutParams();
        layoutParams2.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams2.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams2.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams2.width = 300
        layoutParams2.height = 300
        layoutParams2.x = 500
        layoutParams2.y = 1000

        val button = Button(this)
        button.text = "text"
        windowManager.addView(MainActivity.flutterView, layoutParams)
        windowManager.addView(MainActivity.flutterView2, layoutParams2)
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}

