package com.example.hybrid

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.FlutterEngineHandler
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup

class GlobalApplication : Application() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()

        context = this

        FlutterEngineHandler.init()

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