package com.example.hybrid

import android.app.Service
import android.content.Intent
import android.os.*
import android.view.Gravity
import android.view.WindowManager
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.FlutterEngineHandler

class DemoService : Service() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager;

        val ap = (application as GlobalApplication)

        val layoutParams1 = WindowManager.LayoutParams();
        layoutParams1.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams1.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams1.gravity = Gravity.LEFT or Gravity.TOP
        layoutParams1.width = 300
        layoutParams1.height = 300
        layoutParams1.x = 50
        layoutParams1.y = 100


        windowManager.addView(
            FlutterEngineHandler.getFlutterEnginersByObject.data_center.flutterView,
            layoutParams1
        )

//        val uiHandler: Handler = object : Handler(Looper.getMainLooper()) {
//            override fun handleMessage(msg: Message) {
//                windowManager.removeView((application as GlobalApplication).flutterEngine.flutterView)
//                windowManager.addView(
//                    (application as GlobalApplication).flutterEngine.flutterView,
//                    layoutParams1
//                )
//                println("----------1 111")
//            }
//        }
//
//        class Tt : TimerTask() {
//            override fun run() {
//                uiHandler.sendEmptyMessage(1)
//            }
//
//        }
//
//        Timer().schedule(Tt(), 10000, 10000)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        return super.onStartCommand(intent, flags, startId)
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO()
    }

    override fun onDestroy() {
        super.onDestroy()
        println("-------------- destroy")
    }

}

