package com.example.hybrid

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.app.Application
import android.app.ApplicationExitInfo
import android.content.Context
import android.content.res.Configuration
import com.example.hybrid.engine.manager.FlutterEngineManager
import kotlin.system.exitProcess

class GlobalApplication : Application() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()

        context = this

        println("-------------- Application onCreate")
    }


    override fun onLowMemory() {
        super.onLowMemory()
        // 低内存的时候执行
        println("-------------- Application onLowMemory")
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        // 程序在内存清理的时候执行
        println("-------------- Application onTrimMemory")
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        println("-------------- Application onConfigurationChanged")
    }
}