package com.example.hybrid.engine.service

import android.app.Service
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.FlutterEngineHandler
import com.example.hybrid.engine.NewActivity

class DataCenterService : Service() {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()

        println("---------------- onCreate")
        FlutterEngineHandler.getFlutterEnginersByObject.data_center.create()

        if (!Settings.canDrawOverlays(this)) {
            println("~~~~~~~~ 无权限")
            startActivity(
                Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + this.packageName)
                )
            )
        } else {
            f()
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun f() {

        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager;

        val ap = (application as GlobalApplication)

        val layoutParams1 = WindowManager.LayoutParams();
        layoutParams1.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        layoutParams1.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
        layoutParams1.gravity = Gravity.RIGHT or Gravity.TOP
        layoutParams1.width = 200
        layoutParams1.height = 200
        layoutParams1.x = 50
        layoutParams1.y = 50

        val button = Button(this)

        button.setOnClickListener {
            startActivity(
                Intent(
                    this,
                    NewActivity::class.java
                ).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
        windowManager.addView(
            button,
            layoutParams1
        )
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        println("---------------- onDestroy")
    }
}