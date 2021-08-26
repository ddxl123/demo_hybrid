package com.example.hybrid.engine.service

import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import androidx.annotation.RequiresApi
import com.example.hybrid.GlobalApplication
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.manager.FlutterEnginer
import com.example.hybrid.engine.permission.CheckPermission

class DataCenterService(flutterEnginer: FlutterEnginer) : AbstractService(flutterEnginer) {


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

}