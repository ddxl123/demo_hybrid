package com.example.hybrid

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.Application
import android.app.ApplicationExitInfo
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.test.TestService
import kotlin.system.exitProcess

class GlobalApplication : Application() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
        println("---------------- ${resources.displayMetrics.widthPixels}")
        context = this
        startForegroundService(Intent(this, MainService::class.java))

        println("-------------- Application onCreate")
    }


    // 低内存的时候执行
    override fun onLowMemory() {
        super.onLowMemory()
        println("-------------- Application onLowMemory")
    }

    // 程序在内存清理的时候执行
    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        println("-------------- Application onTrimMemory")
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        println("-------------- Application onConfigurationChanged")
    }
}