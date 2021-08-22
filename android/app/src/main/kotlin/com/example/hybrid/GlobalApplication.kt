package com.example.hybrid

import android.app.Application
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup

class GlobalApplication : Application() {

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreate() {
        super.onCreate()

//        if (!Settings.canDrawOverlays(this)) {
//            println("~~~~~~~~ 无权限")
//            startActivity(
//                Intent(
//                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                    Uri.parse("package:" + this.packageName)
//                )
//            )
//        } else {
//            startService(Intent(this, DemoService::class.java))
//        }
    }
}