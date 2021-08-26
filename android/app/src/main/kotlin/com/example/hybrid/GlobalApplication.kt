package com.example.hybrid

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import com.example.hybrid.engine.manager.FlutterEngineManager

class GlobalApplication : Application() {

    companion object {
        @SuppressLint("StaticFieldLeak")
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()

        context = this

        FlutterEngineManager.init()

    }
}