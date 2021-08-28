package com.example.hybrid.engine.service

import android.app.Service
import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEnginer

abstract class AbstractService : Service() {

    lateinit var flutterEnginer: FlutterEnginer

    abstract fun setFlutterEnginer(): FlutterEnginer

    override fun onCreate() {
        super.onCreate()
        flutterEnginer = setFlutterEnginer()
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractService onCreate")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractService onStartCommand")
        return super.onStartCommand(intent, flags, startId)
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun onDestroy() {
        super.onDestroy()
        println("--------- ${flutterEnginer.entryPointName} 入口的 AbstractService onDestroy")
    }
}