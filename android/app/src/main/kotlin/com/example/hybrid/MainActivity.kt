package com.example.hybrid

import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import com.example.hybrid.engine.manager.FlutterEngineManager
import com.example.hybrid.engine.permission.CheckPermission
import com.example.hybrid.engine.permission.CheckPermissionActivity
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.N)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        FlutterEngineManager.getFlutterEnginersByObject.main.attachMain(flutterEngine!!)

    }
}