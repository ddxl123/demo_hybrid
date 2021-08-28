package com.example.hybrid.engine.service

import android.app.ActivityManager
import android.app.Application
import android.content.Intent
import android.graphics.Rect
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.constant.EngineEntryName
import com.example.hybrid.engine.datatransfer.DataCenterDataTransfer
import com.example.hybrid.engine.floatingwindow.AbstractFloatingWindow
import com.example.hybrid.engine.floatingwindow.DataCenterFloatingWindow
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission

class DataCenterService : AbstractService() {


    @RequiresApi(Build.VERSION_CODES.R)
    override fun setFlutterEnginer(): FlutterEnginer {
        return FlutterEnginer(EngineEntryName.data_center,this,
            { DataCenterDataTransfer(it) },
            { DataCenterFloatingWindow(it, Rect(100, 100, 200, 200), true) })
    }


    override fun onCreate() {
        super.onCreate()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

}